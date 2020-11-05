module Enumerable
    def my_each
        return to_enum(:my_each) unless block_given?

        array = self
        counter = 0
        loop do
        yield array[counter]
        counter += 1
        break if counter == array.length
        end 
    end
    end 