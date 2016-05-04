require "./lib/stock"
stock = Stock.new(9468, :t, 100)
puts stock.code
puts stock.market
puts stock.unit

stock.add_price("2016-04-27", 1578, 1608, 1578, 1593, 28160000)
stock.add_price("2011-04-28", 1610, 1637, 1562, 1572, 40640000)
stock.add_price("2011-05-02", 1511, 1528, 1503, 1515, 20210000)

#puts stock.prices[0][:date]
#puts stock.prices[1][:open]
#puts stock.prices[2][:high]

# オブジェクトの中身をそのまま表示
p stock.prices

#dates = stock.map_prices(:date)
#puts dates[1]

#open_prices = stock.map_prices(:open)
#puts open_prices[0]

#p dates

puts stock.dates[0]
puts stock.open_prices[1]
puts stock.high_prices[2]
puts stock.low_prices[0]
puts stock.close_prices[1]
puts stock.volumes[2]

p stock.open_prices
p stock.low_prices
