require "./lib/stock_list_loader"

sll = StockListLoader.new("data/tosho_list.txt")
puts sll.stock_info[0]
puts sll.codes[0]
puts sll.codes.last
puts sll.market_sections[0]
puts sll.market_sections[1]
puts sll.market_sections[2]
puts sll.market_sections[3]
puts sll.units[0]

puts sll.market_sections.include?("東証2部")
sll.filter_by_market_section("東証1部")
p sll.market_sections
puts sll.market_sections.include?("東証2部")
