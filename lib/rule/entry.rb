require "./lib/rule/rule"

# 仕掛けルールの親クラス
class Entry < Rule
  # 買い仕掛け index-株価データやテクニカル指標のデータの位置
  def check_long_entry(index)
    with_valid_indicators {check_long(index)}
  end

  # 売り仕掛け
  def check_short_entry(index)
    with_valid_indicators {check_short(index)}
  end

  private
  def enter(index, price, long_short, entry_time)
    Trade.new(stock_code: @stock.code,
              trade_type: @stock.dates[index],
              entry_price: price,
              entry_time: entry_time)
  end

  def enter_long(index, price, entry_time)
    enter(index, price, :long, entry_time)
  end

  def enter_short(index, price, entry_time)
    enter(index, price, :short, entry_time)
  end
end
  
