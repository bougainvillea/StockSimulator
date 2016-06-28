require "./lib/base"

# 移動平均のクラス
# 前日の移動平均と本日の移動平均を比べ
# 本日の方が高ければ:up
# 前日の方が高ければ:down
# 同じならば:flat
class MovingAverageDirection < Indicator
  def initialize(stock, params)
    @stock = stock
    @span = params[:span]
  end

  # 最新の終値と@span日前の終値を比べ、
  # 最新値の方が高ければ上昇
  # 最新値の方が低ければ下降
  def calculate_indicator
    @stock.close_prices.map_indicator(@span + 1) do |prices|
      if prices.first < prices.last
        :up
      elsif prices.first > prices.last
        :down
      else
        :flat
      end
    end
  end
end

