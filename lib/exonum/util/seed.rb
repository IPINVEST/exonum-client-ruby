module Exonum
  def self.generate_seed
    SecureRandom.random_bytes(16).unpack('Q<').first
  end
end
