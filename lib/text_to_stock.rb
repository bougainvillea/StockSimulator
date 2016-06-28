require "./lib/stock"
require "./lib/stock_list_loader"
require "date"

# テキストデータからStockクラスのオブジェクトを生成するクラス
class TextToStock
  attr_writer :from, :to

  def initialize(params)
    @data_dir = params[:data_dir] || "data"
    @stock_list = params[:stock_list] || raise("銘柄リストを指定してください")
    @market_section = params[:market_section]
    @list_loader = StockListLoader.new("#{@data_dir}/#{@stock_list}")
  end

  # 株オブジェクトを生成する
    def generate_stock(code)
    # 銘柄リストに含まれる証券コード一覧を取得し、Array#indexで
    # 目的の証券コードのインデックスを返す
      index = @list_loader.codes.index(code)
      # 株オブジェクトを新規作成（証券コード、市場、売買単元株数）
      stock = Stock.new(code, market(index), @list_loader.units[index])
      add_prices_from_data_file(stock)
      stock
    end

  # 銘柄リストにある銘柄について、
  # データディレクトリ内にある株価データから
  # 順番に株オブジェクトを返すイテレータ
  def each_stock
    @list_loader.filter_by_market_section(*@market_section).codes.each do |code|
      # 株価データファイルがある時だけ株オブジェクトを生成
      if File.exist?("#{@data_dir}/#{code}.txt")
        yield generate_stock(code)
      end
    end
  end

  private
  def market(index)
    section = @list_loader.market_sections[index]
    case section
    when /東証|マザーズ/
      :t
    when /名/
      :n
    when /福/
      :f
    when /札/
      :s
    end
  end

  # 株価データを読み込み、各行から株価を取り出し、株オブジェクトに
  # 加える。あらかじめ指定された開始日と終了日の範囲で株価データを取得
  def add_prices_from_data_file(stock)
    lines = File.readlines("#{@data_dir}/#{stock.code}.txt")
    fi = from_index(lines)
    ti = to_index(lines)
    return if fi.nil? || ti.nil?
    lines[fi..ti].each do |line|
      data = line.split(",")
      date = data[0]
      prices_and_volume = data[1..5].map {|d| d.to_i}
      stock.add_price(date, *prices_and_volume)
    end
  end

  def from_index(lines)
    return 0 unless @from # 開始日がなければ株価データの先頭から
    # 日付の形式を整える
    @formatted_from ||= Date.parse(@from).to_s.gsub("-", "/")
    lines.index {|line| line[0..9] >= @formatted_from}
  end

  def to_index(lines)
    return lines.size unless @to
    @formatted_to ||= Date.parse(@to).to_s.gsub("-", "/")
    # Array#rindexは後ろから探す
    lines.rindex {|line| line[0..9] <= @formatted_to}
  end
end


