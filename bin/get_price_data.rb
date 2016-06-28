require "./lib/stock_data_getter"

# 東証銘柄をダウンロードする
# 名証銘柄をダウンロードしたければ、market = :n とする
# 福証なら market = :f、札証なら market = s:

from = "2016/01/4"
#to   = "2011/06/30" # 今日にする場合は to = Date.today.to_s
to = Date.today.to_s
market = :t
sdg = StockDataGetter.new(from, to, market)

#(1300..9999).each do |code|
(1300..1399).each do |code|
 sdg.get_price_data(code)
end
