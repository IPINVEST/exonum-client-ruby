module Exonum
  class ArrayT
    attr_accessor :value_type

    def initialize value_type
      raise 'String arrays are not supported yet' if value_type.is_a?(StringT) 
      self.value_type = value_type
    end

    def size
      8
    end

    def fixed?
      false
    end
    
    def serialize data, buffer, from=0, shift=0
      raise "Expecting array" unless data.is_a?(Array)
      UInt32T.new.serialize buffer.length, buffer, from
      UInt32T.new.serialize data.length, buffer, from + 4
      if value_type.is_a?(StringT)
        start = buffer.length
        (start..(data.length*8-1)).each do |i|
          buffer[i] = 0
        end
        (0..(data.length-1)).each do |i|
          index = start + i*8
          finish = buffer.length
          UInt32T.new.serialize finish - shift, buffer, index
          value_type.serialize data[i], buffer, finish
          UInt32T.new.serialize buffer.length - finish, buffer, index + 4
        end
      elsif value_type.is_a?(ArrayT)
        start = buffer.length
        (start..(data.length*8-1)).each do |i|
          buffer[i] = 0
        end
        (0..(data.length-1)).each do |i|
          index = start + i*8
          value_type.serialize data[i], buffer, shift
        end
      else
        data.each do |item|
          bufferLength = buffer.length
          value_type.serialize item, buffer, bufferLength, bufferLength + value_type.size
        end
      end
    end
  end
end
