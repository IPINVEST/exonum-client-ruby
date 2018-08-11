require 'exonum'

RSpec.describe 'serialization' do
  it "can serialize simple structure" do
    fields = [
      { name: 'pubkey', type: Exonum::PublicKeyT }, 
      { name: 'owner', type: Exonum::StringT }, 
      { name: 'balance', type: Exonum::UInt64T }
    ]
    data = { 'pubkey' => '99ace6c721db293b0ed5b487e6d6111f22a8c55d2a1b7606b6fa6e6c29671aa1', 'owner' => 'Andrew', 'balance' => 1234 }
    buffer = SparseArray.new
    s = Exonum::StructT.new fields
    s.serialize data, buffer
    expect(buffer.serialize.pack('c*').unpack('H*').first).to eq("99ace6c721db293b0ed5b487e6d6111f22a8c55d2a1b7606b6fa6e6c29671aa13000000006000000d204000000000000416e64726577")
  end

  it "can serialize array" do
    a=Exonum::ArrayT.new Exonum::Int16T
    buffer = SparseArray.new
    a.serialize [1,2,3], buffer
    expect(buffer.serialize.pack('c*').unpack('H*').first).to  eq("0000000003000000010002000300")
  end

  it "can sign a message" do
    secret = "867103771411a6d8e14dd2b037bb5b57ab0add4debdc39147f9d2eae342a388d29823166d18e2471a19b16d261fe329f1228048846c1acea2f370e6a89c7a4d9"
    signature = "46386a5ef9ad0ac5d1e2fe509e3e3bfa27f4f0d376628169df76b5c02f77f8699ed966031a42bbc1a94002c4ec666f4e7d143a481e19eee306a2dfd8280c3d0e"

    fields = [
      { name: 'pub_key', type: Exonum::PublicKeyT },
      { name: 'amount', type: Exonum::UInt64T },
      { name: 'seed', type: Exonum::UInt64T }
    ]
    data = {
      'pub_key' => "29823166d18e2471a19b16d261fe329f1228048846c1acea2f370e6a89c7a4d9",
      'amount' => 10,
      'seed' => 4645085842425400387
    }
    message = Exonum::MessageT.new 0, 1, 128, Exonum::StructT.new(fields)
    expect(message.sign(secret, data)).to eq(signature)
  end

  it "can generate seed" do
    expect(Exonum::Random.generate_seed.is_a? String).to be true
  end

  it "can generate keypair" do
    keypair = Exonum::Random.generate_keypair
    data = 'test'
    signing_key = Ed25519::SigningKey.new [keypair[:private]].pack('H*')
    verify_key = Ed25519::VerifyKey.new [keypair[:public]].pack('H*')
    signature = signing_key.sign data
    expect(verify_key.verify signature, data).to be true
  end
end
