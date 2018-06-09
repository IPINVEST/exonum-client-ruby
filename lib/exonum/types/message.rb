module Exonum
  class MessageT
    attr_accessor :protocol_version
    attr_accessor :message_id
    attr_accessor :service_id
    attr_accessor :head
    attr_accessor :body
    attr_accessor :signature

    def initialize protocol_version, message_id, service_id, body
      self.protocol_version = protocol_version
      self.message_id = message_id
      self.service_id = service_id
      self.head = StructT.new([
        { name: 'network_id', type: UInt8T },
        { name: 'protocol_version', type: UInt8T },
        { name: 'message_id', type: UInt16T },
        { name: 'service_id', type: UInt16T },
        { name: 'payload', type: UInt32T }
      ])
      self.body = body
    end

    def serialize data
      buffer = SparseArray.new
      head_data = {
        network_id: 0,
        protocol_version: self.protocol_version,
        message_id: self.message_id,
        service_id: self.service_id,
        payload: 0 # placeholder, real value will be inserted later
      }
      head.serialize head_data, buffer, 0
      body.serialize data, buffer, head.size, 0, true
      UInt32T.serialize buffer.length + SignatureT.size, buffer, 6
      buffer.serialize
    end

    def sign secret, data
      raise "Expecting 64 bytes key in hex" unless secret.is_a?(String) and secret.length == 128
      key = Ed25519::SigningKey.new [secret[0..63]].pack 'H*'
      buffer = serialize(data).pack('c*')
      key.sign(buffer).unpack('H*').first
    end
  end
end
