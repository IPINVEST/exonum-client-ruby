# Exonum Client Ruby

Light client for Exonum blockchain framework. [Exonum homepage](https://exonum.com)

## Current state

Pre alpha

## Usage

Posting a transaction:

    require 'exonum'
    require 'rest_client'

    keypair = Exonum::Random.generate_keypair

    message = Exonum::MessageT.new 0, 2, 128, Exonum::StructT.new([
      { name: 'pub_key', type: Exonum::PublicKeyT },
      { name: 'name', type: Exonum::StringT }
    ])

    data = {
      pub_key: keypair[:public],
      name: 'John Doe'
    }

    signature = message.sign "#{keypair[:private]}#{keypair[:public]}", data

    JSON.parse RestClient.post(
      'http://127.0.0.1:8200/api/services/cryptocurrency/v1/wallets/transaction', 
      {
        protocol_version: 0,
        message_id: 2,
        service_id: 128,
        signature: signature,
        body: data
      }.to_json,
      {content_type: :json, accept: :json}
    )


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
