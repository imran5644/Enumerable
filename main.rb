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
    p selected_elts
  end

  def my_all?(word = nil)
    if block_given?
        my_each do |elt|
            return false unless yield(elt) == true
        end
        true
    elsif word.nil?
        my_each { |elt| return false if elt.nil? || elt == false }
      elsif !arg.nil? && (arg.is_a? Class)
        my_each { |elt| return false if elt.class != arg }
      elsif !arg.nil? && arg.class == Regexp
        my_each { |elt| return false unless arg.match(elt) }
      else
        my_each { |elt| return false if elt != arg }
      end
      true
    end
  end

  def my_any?(word=nil)
    if block_given?
        my_each do |elt|
            return true unless yield(elt) == false
        end
        false
    elsif word.nil?
        my_each { |elt| return true if elt.nil? || elt == true }
    elsif !arg.nil? && (arg.is_a? Class)
        my_each { |elt| return true if elt.class != arg }
    elsif !arg.nil? && arg.class == Regexp
        my_each { |elt| return true unless arg.match(elt) }
    else
        my_each { |elt| return true if elt != arg }
    end
    false
end

def my_none?
    return to_enum(:my_none) unless block_given?
    
    arr = self
    index = 0
    my_each do |elt|
    if (yield(elt) == false) && (index < arr.length)
    index += 1
    elsif yield(elt) == true
    return false
    end
    return true
end
def my_count(number = nil)
    arr = self
    new_arr = []
    if block_given? && number==nil
      new_arr<<arr.to_a.my_select { |elt| elt == yield(elt) }
    elsif number
      arr.my_select { |elt| elt == number }.length
    else
      arr.length
    end
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
     memo =memo.nil? ? elt :memo.send(num, elt)
    end
   memo
  elsif !sym.nil? && (sym.is_a?(Symbol) || sym.is_a?(String))
   memo = num
    my_each do |elt|
     memo =memo.nil? ? elt :memo.send(sym, elt)
    end
   memo
  end
end
[1, 2, 3, 4].my_each do |element|
  puts element
end
[3, 1, 3, 2].my_each_with_index do |element, index|
  print element, index
end
(1..4).my_each_with_index do |element, index|
  print element, index
end
