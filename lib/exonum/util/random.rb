module Exonum
  module Random
    def self.generate_seed
      SecureRandom.random_bytes(16).unpack('Q<').first
    end

    def self.generate_keypair
      key = Ed25519::SigningKey.generate
      {
        public: key.verify_key.to_bytes.unpack('H*').first,
        private: key.to_bytes.unpack('H*').first
      }
    end
  end
end
