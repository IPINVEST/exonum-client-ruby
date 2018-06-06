# Exonum Client Ruby

Light client for Exonum blockchain framework. [Exonum homepage](https://exonum.com)

## Current state

Pre alpha

## Usage

Signing a message:

    # Ed25519 private key in hex
    secret = '867103771411a6d8e14dd2b037bb5b57ab0add4debdc39147f9d2eae342a388d29823166d18e2471a19b16d261fe329f1228048846c1acea2f370e6a89c7a4d9'
    # Message params template
    fields = [
      { name: 'pub_key', type: Exonum::PublicKeyT.new },
      { name: 'amount', type: Exonum::UInt64T.new },
      { name: 'seed', type: Exonum::UInt64T.new }
    ]

    # Message params values
    data = {
      'pub_key' => "29823166d18e2471a19b16d261fe329f1228048846c1acea2f370e6a89c7a4d9",
      'amount' => 10,
      'seed' => 4645085842425400387
    }

    # protocol_version: 0, message_id: 1, service_id: 128 
    message = Exonum::MessageT.new 0, 1, 128, Exonum::StructT.new(fields)

    # get ed25519 signature in hex
    # 46386a5ef9ad0ac5d1e2fe509e3e3bfa27f4f0d376628169df76b5c02f77f8699ed966031a42bbc1a94002c4ec666f4e7d143a481e19eee306a2dfd8280c3d0e
    message.sign(secret, data)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
