# 銘柄リストを読み込み、銘柄に関する情報を供給するクラス
class StockListLoader
  def initialize(stock_list_file)
    unless stock_list_file
      raise "銘柄リストを指定してください"
    end
    # 銘柄リストの読み込み
    @stock_list =
      File.readlines(stock_list_file).map do |line|
        line.split(",")
      end
  end

  # 証券コード、上場市場、単元株数からなるハッシュの銘柄ごとの
  # 配列を作る。initializeで作った@stock_listから情報を取り出す
  def stock_info
    @stock_info ||= @stock_list.map do |data|
      {:code => data[0].to_i, :market_section => data[1], :unit => data[2].to_i}
    end
  end

  def codes
    @codes ||= stock_info.map {|info| info[:code]}
  end

  def market_sections
    @market_sections ||= stock_info.map {|info| info[:market_section]}
  end

  def units
    @units ||= stock_info.map {|info| info[:unit]}
  end

  # シミュレートする銘柄を東証1部に限りたいというケースで使用
  # 引数が*sectionsなので、複数の上場部を対象にできる
  def filter_by_market_section(*sections)
    # 引数が与えられない、nilの場合はStockListMakerのインスタンスを返す
    return self unless sections[0]
    # find_allで配列要素のうち、条件に合うものを全て取り出して新しい配列を返す
    @stock_info = stock_info.find_all do |info|
      # include?でsectionsに:market_sectionと同じものが入っていないか判断
      sections.include?(info[:market_section])
    end
    puts @stock_info
    # StockListLoaderクラスから作られたオブジェクト自身を返す
    self
  end
end
