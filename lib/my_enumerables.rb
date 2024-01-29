module Enumerable
  def my_each_with_index
    i = 0
    self.each do |e|
      yield(e, i)
      i += 1
    end 
  end

  def my_select
    filtered = []
    self.each { |e| filtered.push(e) if yield(e) }
    filtered
  end

  def my_all?
    self.each { |e| return false unless yield(e) }
    true
  end

  def my_any?
    self.each { |e| return true if yield(e) }
    false
  end
  
  def my_none?
    self.each { |e| return false if yield(e) }
    true
  end

  def my_count
    return self.size unless block_given?
    count = 0
    self.each { |e| count += 1 if yield(e) }
    count
  end

  def my_map
    map = []
    self.each { |e| map.push(yield(e)) }
    map
  end

  def my_inject(*args, &block)
    initial = nil
    symbol = nil
    if args.size == 2
      initial, symbol = args[0], args[1]
    elsif args.size == 1 && !block_given?
      initial, symbol = nil, args.first
    elsif args.size == 1
      initial, symbol = args.first, nil
    end
    acc = initial || self.first
    arr = initial ? self : self.drop(1)
    if block_given?
      arr.each { |e| acc = yield(acc, e) }
    else
      arr.each { |e| acc = acc.send(symbol, e) }
    end
    acc
  end
end

p ('a'..'d').my_inject(:+)
p ('a'..'d').my_inject('foo', :+) 
p (1..4).my_inject(10, :+) 
p (1..4).my_inject(2) {|sum, n| sum + n*n }
# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each
    for e in self
      yield e
    end
  end
end
