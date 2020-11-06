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
      my_each { |elt| return false if yield(elt) }
      return true
    end
    arg.nil? ? arg.class.to_s : my_all? { |elt| elt }

    case arg.class.to_s
    when 'Class'
      my_all? { |elt| elt.is_a? arg }
    when 'Regexp'
      my_all? { |elt| elt =~ arg }
    else
      my_all? { |elt| elt == arg }
    end
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |elt| return true if yield(elt) }
      return false
    end
    arg.nil? ? arg.class.to_s : my_any? { |elt| elt }

    if arg.class.to_s == 'Class'
      my_each { |elt| return true if elt.is_a? arg }
    elsif arg.class.to_s == 'Regexp'
      my_each { |elt| return true if elt =~ arg }
    elsif arg.nil?
      my_each { |elt| return true if elt }
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
  def my_inject(arg = nil, sym = nil)
    if (arg.is_a?(Symbol) || arg.is_a?(String)) && (!arg.nil? && sym.nil?)
      sym = arg
      arg = nil
    end
  
    if !block_given? && !sym.nil?
      my_each { |elt| arg = arg.nil? ? elt : arg.send(sym, elt) }
    else
      my_each { |elt| arg = arg.nil? ? elt : yield(arg, elt) }
    end
    arg
  end
end


def multiply_els(elts)
  elts.my_inject { |result, elt| result * elt }
end
# 1. my_each
puts 'my_each'
puts '-------'
puts [1, 2, 3].my_each { |elem| print "#{elem + 1} " }
# => 2 3 4
puts
# 2. my_each_with_index
puts 'my_each_with_index'
puts '------------------'
print [1, 2, 3].my_each_with_index { |elem, idx| puts "#{elem} : #{idx}" }
# => 1 : 0, 2 : 1, 3 : 2
puts
# 3. my_select
puts 'my_select'
puts '---------'
p [1, 2, 3, 8].my_select(&:even?) # => [2, 8]
p [0, 2018, 1994, -7].my_select(&:positive?) # => [2018, 1994]
p [6, 11, 13].my_select(&:odd?) # => [11, 13]
puts
# 4. my_all? (example test cases)
puts 'my_all?'
puts '-------'
p [3, 5, 7, 11].my_all?(&:odd?) # => true
p [-8, -9, -6].my_all?(&:negative?) # => true
p [3, 5, 8, 11].my_all?(&:odd?) # => false
p [-8, -9, -6, 0].my_all?(&:negative?) # => false
# test cases required by tse reviewer
p [1, 2, 3, 4, 5].my_all?(3) # => false
p [1, 2.5, 'a', 3].my_all?(Integer) # => false
p %w[dog door rod blade].my_all?(/o/) # => false
p [1, 1, 1].my_all?(1) # => true
puts
# 5. my_any? (example test cases)
puts 'my_any?'
puts '-------'
p [7, 10, 3, 5].my_any?(&:even?) # => true
p [7, 10, 4, 5].my_any?(&:even?) # => true
p %w[q r s i].my_any? { |char| 'aeiou'.include?(char) } # => true
p [7, 11, 3, 5].my_any?(&:even?) # => false
p %w[q r s t].my_any? { |char| 'aeiou'.include?(char) } # => false
# test cases required by tse reviewer
p [nil, false, nil, false].my_any? # => false
p [1, nil, false].my_any?(Integer) # => true
p %w[dog door rod blade].my_any?(/z/) # => false
p [1, 2, 3].my_any?(1) # => true
puts
# 6. my_none? (example test cases)
puts 'my_none?'
puts '--------'
p [3, 5, 7, 11].my_none?(&:even?) # => true
p %w[sushi pizza burrito].my_none? { |word| word[0] == 'a' } # => true
p [3, 5, 4, 7, 11].my_none?(&:even?) # => false
p %w[asparagus sushi pizza apple burrito].my_none? { |word| word[0] == 'a' } # => false
# test cases required by tse reviewer
p [nil, false, nil, false].my_none? # => true
p [1, 2, 3].my_none? # => false
p [1, 2, 3].my_none?(String) # => true
p [1, 2, 3, 4, 5].my_none?(2) # => false
p [1, 2, 3].my_none?(4) # => true
puts
# 7. my_count (example test cases)
puts 'my_count'
puts '--------'
p [1, 4, 3, 8].my_count(&:even?) # => 2
p %w[DANIEL JIA KRITI dave].my_count { |s| s == s.upcase } # => 3
p %w[daniel jia kriti dave].my_count { |s| s == s.upcase } # => 0
# test cases required by tse reviewer
p [1, 2, 3].my_count # => 3
p [1, 1, 1, 2, 3].my_count(1) # => 3
puts
# 8. my_map
puts 'my_map'
puts '------'
p [1, 2, 3].my_map { |n| 2 * n } # => [2,4,6]
p %w[Hey Jude].my_map { |word| "#{word}?" } # => ["Hey?", "Jude?"]
p [false, true].my_map(&:!) # => [true, false]
my_proc = proc { |num| num > 10 }
p [18, 22, 5, 6].my_map(my_proc) { |num| num < 10 } # => true true false false
puts
# 9. my_inject
puts 'my_inject'
puts '---------'
p [1, 2, 3, 4].my_inject(10) { |accum, elem| accum + elem } # => 20
p [1, 2, 3, 4].my_inject { |accum, elem| accum + elem } # => 10
p [5, 1, 2].my_inject('+') # => 8
p(5..10).my_inject(4) { |prod, n| prod * n } # should return
