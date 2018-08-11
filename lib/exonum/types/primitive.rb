module Exonum
  MIN_INT8 = -128
  MAX_INT8 = 127
  MIN_INT16 = -32768
  MAX_INT16 = 32767
  MIN_INT32 = -2147483648
  MAX_INT32 = 2147483647
  MIN_INT64 = -9223372036854775808
  MAX_INT64 = 9223372036854775807
  MAX_UINT8 = 255
  MAX_UINT16 = 65535
  MAX_UINT32 = 4294967295
  MAX_UINT64 = 18446744073709551615
  FLOAT_PRECISION_MULTIPLIER = 10.0 ** 6

  class Int8T
    def self.size
      1
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise 'Incorrect integer value' if value < MIN_INT8 or value > MAX_INT8
      [value].pack('c').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class UInt8T
    def self.size
      1
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise 'Incorrect integer value' if value < 0 or value > MAX_UINT8
      [value].pack('C').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class Int16T
    def self.size
      2
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise 'Incorrect integer value' if value < MIN_INT16 or value > MAX_INT16
      [value].pack('s<').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class UInt16T
    def self.size
      2
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise 'Incorrect integer value' if value < 0 or value > MAX_UINT16
      [value].pack('S<').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class Int32T
    def self.size
      4
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise 'Incorrect integer value' if value < MIN_INT32 or value > MAX_INT32
      [value].pack('l<').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class UInt32T
    def self.size
      4
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise 'Incorrect integer value' if value < 0 or value > MAX_UINT32
      [value].pack('L<').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class Int64T
    def self.size
      8
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      [value.to_i].pack('q<').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class UInt64T
    def self.size
      8
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      [value.to_i].pack('Q<').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class Float32T
    def self.size
      4
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      value = (value * FLOAT_PRECISION_MULTIPLIER).round / FLOAT_PRECISION_MULTIPLIER
      [value].pack('e').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class Float64T
    def self.size
      8
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      value = (value * FLOAT_PRECISION_MULTIPLIER).round / FLOAT_PRECISION_MULTIPLIER
      [value].pack('E').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class BoolT
    def self.size
      1
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      buffer[from] = value ? 1 : 0
    end
  end

  class PublicKeyT
    def self.size
      32
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise "Expecting #{size} bytes in hex" unless value.is_a?(String) and value.length == size*2
      [value].pack('H*').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class HashT
    def self.size
      32
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise "Expecting #{size} bytes in hex" unless value.is_a?(String) and value.length == size*2
      [value].pack('H*').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class SignatureT
    def self.size
      64
    end

    def self.fixed?
      true
    end

    def self.serialize value, buffer, from, shift=0
      raise "Expecting #{size} bytes in hex" unless value.is_a?(String) and value.length == size*2
      [value].pack('H*').bytes.each do |byte|
        buffer[from] = byte
        from += 1
      end
    end
  end

  class StringT
    def self.size
      8
    end

    def self.fixed?
      false
    end
    
    def self.serialize value, buffer, from, shift=0
      raise "Expecting string" unless value.is_a?(String)
      bufferLengthOld = buffer.length
      bufferLengthNew = bufferLengthOld
      UInt32T.serialize(bufferLengthOld - shift, buffer, from) # index where string content starts in buffer
      value.bytes.each do |byte|
        buffer[bufferLengthNew] = byte
        bufferLengthNew += 1
      end
      UInt32T.serialize(bufferLengthNew - bufferLengthOld, buffer, from + 4) # string length
    end
  end
end
