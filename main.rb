# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    arr = self
    counter = 0
    loop do
      yield arr.to_a[counter]
      counter += 1
      break if counter == arr.to_a.length
    end
  end

  def my_each_with_index
    return to_enum(:my_each) unless block_given?

    arr = self
    counter = 0
    loop do
      yield(arr.to_a[counter], counter)
      counter += 1
      break if counter == arr.to_a.length
    end
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = self
    counter = 0
    selected_elts = []
    until counter == arr.length
      selected_elts << arr[counter] if yield(arr[counter])
      counter += 1
    end
    selected_elts
  end

  def my_all?(arg = nil)
    if block_given?
      my_each do |elt|
        return false unless yield(elt) == true
      end
      true
    elsif arg.nil?
      my_each { |elt| return false if elt.nil? || elt == false }
    elsif !arg.nil? && (arg.is_a? Class)
      my_each do |elt|
        return true unless elt.instance_of?(arg.class)
      end
      false
    elsif !arg.nil? && arg.instance_of?(Regexp)
      my_each { |elt| return false unless elt.match(arg) }
      true
    end
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |elt| return true if yield(elt) }
      false
    elsif arg.nil?
      my_each { |elt| return true if elt.nil? || elt == true }
    elsif !arg.nil? && (arg.is_a? Class)
      my_each { |elt| return true unless elt.class != arg }
      false
    elsif !arg.nil? && (arg.instance_of? Regexp)
      my_each { |elt| return true if arg.match(elt) }
      false
    else
      my_each { |elt| return true if elt == arg }
    end
    false
  end

  def my_none?(arg = nil)
    return to_enum(:my_none) unless block_given?

    if block_given?
      my_each { |elt| return false if yield(elt) }
      true
    elsif !arg.nil? && (arg.instance_of? Regexp)
      my_each { |elt| return false if elt.match(arg) }
      true
    elsif !arg.nil? && (arg.is_a? Class)
      my_each { |elt| return false unless elt.instance_of?(arg) }
      true
    end
  end

  def my_count(number = nil, &block)
    arr = to_a
    return arr.length unless block_given? || number

    return arr.my_select { |elt| elt == number }.length if number

    arr.my_select(&block).length
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given? || proc.nil?

    arr = self
    new_arr = []
    if proc.nil?
      arr.my_each { |elt| new_arr << yield(elt) }
    else
      arr.to_a.my_each { |elt| new_arr << proc.call(elt) }
    end
    new_arr
  end
end

def my_inject(num = nil, sym = nil)
  if block_given?
    memo = num
    my_each do |elt|
      memo = memo.nil? ? elt : yield(memo, elt)
    end
    memo
  elsif !num.nil? && (num.is_a?(Symbol) || num.is_a?(String))
    memo = nil
    my_each do |elt|
      memo = memo.nil? ? elt : memo.send(num, elt)
    end
    memo
  elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
    memo = num
    my_each do |elt|
      memo = memo.nil? ? elt : memo.send(sym, elt)
    end
    memo

  end
end
[1, 2, 3, 4].my_each do |element|
  puts element
end
[3, 1, 3, 2].my_each_with_index do |element, index|
  puts element
  print index
end
(1..4).my_each_with_index do |element, index|
  puts element
  print index
  puts ''
end
p [1, 2, 3, 4, 5].my_select(&:even?)
p1 = %w[ant bear cat].my_any? { |wor| wor.length >= 3 }
p2 = [nil, true, 99].my_any?(Integer)
p3 = %w[ant bear cat].my_any?(/bos/)
p4 = %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
p5 = [1, 2i, 3.14].my_all?(Numeric)
p6 = %w[ant bear cat].my_all?(/t/)
p7 = [2, 3, 56, 6, 3, 2, 9, 1, 2, 3, 3, 5].my_count
p8 = (0..5).my_count(2)
p9 = %w[ant bear cat].my_none? { |word| word.length == 5 }
p10 = %w[ant bear cat].my_none? { |word| word.length >= 4 }
puts p1
puts p2
puts p3
puts p4
puts p5
puts p6
puts p7
puts p8
puts p9
puts p10
