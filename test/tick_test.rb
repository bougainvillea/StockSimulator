require "./lib/tick"

puts Tick.size(100)
puts Tick.size(2999)
puts Tick.size(3000)
puts Tick.size(3001)
puts Tick.size(4000)
puts Tick.size(5100)
puts Tick.size(30000)
puts Tick.size(30050)
puts
puts Tick.truncate(99.99)
puts Tick.truncate(3004)
puts Tick.truncate(3006)
puts
puts Tick.ceil(99.99)
puts Tick.ceil(3004)
puts Tick.ceil(3006)
puts
puts Tick.round(99.99)
puts Tick.round(99.49)
puts Tick.round(3004)
puts Tick.round(3002)
puts
puts Tick.up(100)
puts Tick.up(100, 3)
puts Tick.up(2999, 1)
puts Tick.up(2999, 2)
puts Tick.up(3000)
puts
puts Tick.down(100)
puts Tick.down(100, 3)
puts Tick.down(3005, 1)
puts Tick.down(3005, 2)
puts Tick.down(3000)
puts Tick.down(3001)

