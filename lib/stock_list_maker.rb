require "open-uri"

# Yahooの銘柄情報ページから情報を取得し、
# 銘柄リストを作るクラス
# 証券コード、上場市場、単元株数・売買単位が含まれる
class StockListMaker
  attr_accessor :data_dir, :file_name

  def initialize(market)
    @market = market    # 取り扱う市場
    @data_dir = "data"  # データの保存場所
    @stock_info = []    # 銘柄情報（証券コード、市場、単元株数）の配列（ハッシュ）
  end

  # 銘柄情報の取得（Yahoo銘柄情報ページからcodeで指定した証券コードの銘柄情報を取得）
  def get_stock_info(code)
    page = open_page(code) # codeで指定した銘柄情報ページを開く
    return unless page # ページが空（）ならメソッドを終了（nilを返す）
    text = page.read.encode("UTF-8", :undef => :replace) # pageから文字を読み込む
    data = parse(text) # 上場市場と単元株数のハッシュが返る
    data[:code] = code # dataの銘柄情報に証券コードを追加
    return unless data[:market_section] # 上場廃止銘柄等の場合、メソッドを抜ける
    puts code
    @stock_info << data
  end

  # 銘柄情報の保存（get_stock_infoによって得た銘柄情報をテキストファイルに保存）
  def save_stock_list
    # ファイルを書き込みモードで開く
    File.open(@data_dir + "/" + @file_name, "w") do |file|
      # @stock_infoからひとつずつ銘柄情報を取り出してファイルに書き込む
      @stock_info.each do |data|
        file.puts [data[:code], data[:market_section], data[:unit]].join(",")
      end
    end
  end

  private
  # 銘柄情報ページを開く
  def open_page(code)
    begin
      open("http://stocks.finance.yahoo.co.jp/stocks/detail/?code=#{code}.#{@market}")
    rescue OpenURI::HTTPError
      # ページ取得失敗の場合（Not Found等）の場合、飛ばして次に行く
      return
    end
  end

  # HTML（引数text）から銘柄情報を抜き出す
  def parse(text)
    data = Hash.new
    sections = []
    reg_market = /tockMainTabName">([^< ]+) ?</ # 市場
    reg_unit = %r!<dd class="ymuiEditLink mar0"><strong>((?:\d|,)+|---)</strong>株</dd>! # 単元株数
    # テキストを1行ずつ見ていく（改行\nごと）
    text.lines do |line|
      if l = line.match(reg_market)
        # マッチした中の最後のグループに相当する文字（$+ ->マザーズ、東証1部等）をsectionsに追加
        sections << l[1]
      elsif l = line.match(reg_unit)
        puts sections[0]
        data[:market_section] = sections[0]
        data[:unit] = get_unit(l[1])
        return data
      end
    end
    data # ページが存在しない等、textから銘柄情報が得られない場合、空のハッシュを返す
  end

  # 単元株数を得る（数字に直す）
  def get_unit(str)
    if str == "---"
      "1"
    else
      # ,を取る
      str.gsub(/,/,"")
    end
  end
end

