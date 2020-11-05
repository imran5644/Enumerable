# frozen_string_literal: true

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

   arr = self
    counter = 0
    loop do
      yield arr[counter]
      counter += 1
      break if counter == arr.length
    end
  end
  def my_each_with_index
    return to_enum(:my_each) unless block_given?
    arr = self
    counter = 0
    loop do
      yield(arr[counter], counter)
      counter += 1
      break if counter == arr.length
    end
  end
  
  def my_select
    return to_enum(:my_select) unless block_given?
    
   arr = self
    counter = 0
    selected_elements = []
    until counter ==arr.length
    selected_elements <<arr[counter] if yield(arr[counter])
    counter += 1
    end
    p selected_elements
    end
    def my_all?(word = nil)
        return to_enum(:my_all) unless block_given?
        return false if word == ''
    
        my_each do |element|
          return false unless yield(element) == true
        end
        true
      end
end
