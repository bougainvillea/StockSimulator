require "pp"
require "./lib/stock"
require "./lib/base"

# Entryから仕掛けクラスを作るテスト
class MyEntry < Entry
  def check_long(index)
    enter_long(index, 100, :close) if index % 2 == 0
  end

  def check_short(index)
    enter_short(index, 100, :close) if index % 2 == 1
  end
end

stock = Stock.new(1000, :t, 100)
entry = MyEntry.new
entry.stock = stock
pp entry.check_long_entry(0) 
pp entry.check_long_entry(1)
puts
pp entry.check_short_entry(0)
pp entry.check_short_entry(1)
puts

# Exitから手仕舞いクラスを作るテスト
class MyExit < Exit
  def check_long(trade, index)
    exit(trade, index, 105, :close) if index % 2 == 1
  end

  def check_short(trade, index)
    exit(trade, index, 95, :close) if index % 2 == 0
  end
end

my_exit = MyExit.new
my_exit.stock = stock
trade1 = entry.check_long(0)
my_exit.check_exit(trade1, 1)
puts trade1.entry_price
puts trade1.exit_price
puts
trade2 = entry.check_short(1)
my_exit.check_exit(trade2, 2)
puts trade2.entry_price
puts trade2.exit_price
puts

# Stopからストップクラスを作るテスト
class MyStop < Stop
  def stop_price_long(position, index)
    Tick.down(position.entry_price, 5)
  end

  def stop_price_short(position, index)
    Tick.up(position.entry_price, 5)
  end
end

stop = MyStop.new
trade3 = entry.check_long(0)
puts stop.get_stop(trade3, 0)
trade4 = entry.check_short(1)
puts stop.get_stop(trade4, 1)
puts

# Filterからフィルタークラスを作るテスト
class MyFilter < Filter
  def filter(index)
    case index % 4
    when 0
      :long_only
    when 1
      :short_only
    when 2
      :no_entry
    when 3
      :long_and_short
    end
  end
end

filter = MyFilter.new
p filter.get_filter(0)
p filter.get_filter(1)
p filter.get_filter(2)
p filter.get_filter(3)

p "終了"
