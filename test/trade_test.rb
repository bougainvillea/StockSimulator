require "./lib/trade"

trade = Trade.new(stock_code: 8604,
                  trade_type: :long,
                  entry_date: "2011/11/14",
                  entry_price: 251,
                  entry_time: :open,
                  volume: 100)

puts trade.stock_code
puts trade.entry_date
puts trade.entry_price
puts trade.long?
puts trade.short?
puts trade.closed?

trade.first_stop = 241
trade.stop = 241
trade.length = 1

puts trade.first_stop
puts trade.stop
puts trade.r
puts trade.length

trade.length += 1

puts trade.length

trade.exit(date: "2011/11/15",
           price: 255,
           time: :in_session)

puts trade.closed?
puts trade.exit_date
puts trade.profit
puts trade.percentage_result
puts trade.r_multiple

