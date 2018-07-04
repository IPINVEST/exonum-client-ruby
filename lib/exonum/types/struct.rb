module Exonum
  class StructT
    attr_accessor :fields
    
    def initialize fields
      raise 'Expecting array parameter' unless fields.is_a?(Array)
      fields.each do |field|
        raise 'Name property is missing' unless field[:name].present?
        raise 'Type property is missing' unless field[:type].present?
      end
      self.fields = fields
    end

    def size
      fields.map do |field| 
        if field[:type].fixed?
          field[:type].size 
        else
          8
        end
      end.reduce(&:+)
    end

    def fixed?
      fields.map {|f| f[:type].fixed? }.reduce(&:&)
    end

    def serialize data, buffer, from=0, shift=0, isTransactionBody=false
      (0..(size-1)).each do |i|
        buffer[from+i] = 0
      end
      localShift = 0
      fields.each do |field|
        value = data.with_indifferent_access[field[:name]]
        raise "Field #{field[:name]} is not defined" if value.nil?
        localFrom = from + localShift
        nestedShift = isTransactionBody ? 0 : shift
        if field[:type].is_a?(StructT)
          if field[:type].fixed?
            field[:type].serialize value, buffer, localFrom, nestedShift
            localShift += field[:type].size
          else
            bufferLengthOld = buffer.length
            UInt32T.serialize(bufferLengthOld - nestedShift, buffer, localFrom) # index where string content starts in buffer
            field[:type].serialize value, buffer, bufferLengthOld, nestedShift
            bufferLengthNew = buffer.length
            UInt32T.serialize(bufferLengthNew - bufferLengthOld, buffer, localFrom + 4) # string length
            localShift += 8
          end
        else
          field[:type].serialize value, buffer, localFrom, nestedShift
          localShift += field[:type].size
          #puts "\n\n#{field[:type].class.name}, #{value}, #{localFrom}, #{nestedShift}"
          #puts buffer.serialize.inspect
        end
      end
    end
  end
end
