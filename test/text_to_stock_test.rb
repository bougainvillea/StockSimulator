require "./lib/text_to_stock"

tts = TextToStock.new(data_dir: "data",
                      stock_list: "tosho_list.txt",
                      market_section: "東証1部")
stock = tts.generate_stock(1301)
puts stock.code
puts stock.dates.first
puts stock.open_prices.first

tts.each_stock do |stock|
  puts stock.code
end

# 開始日と終了日を指定
tts.from = "2015/01/04"
tts.to   = "2015/06/30"

tts.each_stock do |stock|
  puts [stock.code, stock.dates.first, stock.dates.last].join(" ")
end
