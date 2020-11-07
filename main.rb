# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    arr = to_a
    counter = 0
    loop do
      yield arr.to_a[counter]
      counter += 1
      break if counter == arr.to_a.length
    end
    self
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
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    arr = to_a
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
      my_each { |item| return false if yield(item) == false }
      return true
    elsif arg.nil?
      my_each { |n| return false if n.nil? || n == false }
    elsif !arg.nil? && (arg.is_a? Class)
      my_each { |n| return false if n.class != arg }
    elsif !arg.nil? && arg.instance_of?(Regexp)
      my_each { |n| return false unless arg.match(n) }
    else
      my_each { |n| return false if n != arg }
    end
    true
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

  def my_none?(arg = nil, &block)
    !my_any?(arg, &block)
  end

  def my_count(number = nil, &block)
    arr = to_a
    return arr.length unless block_given? || number

    return arr.my_select { |elt| elt == number }.length if number

    arr.my_select(&block).length
  end

  def my_map(proc = nil)
    return to_enum(:my_map) unless block_given?

    arr = to_a
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
