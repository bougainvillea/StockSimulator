require "./lib/stock_data_getter"

# 東証銘柄をダウンロードする
# 名証銘柄をダウンロードしたければ、 market = :n とする
# 福証なら market = :f、札証なら market = :s

from = "2016/01/04" # get_price_data.rbのfromと同じ日付に
to   = Date.today.to_s
market = :t
ydg = StockDataGetter.new(from, to, market)

#(1300..9999).each do |code|
(1300..1399).each do |code|
  ydg.update_price_data(code)
end
