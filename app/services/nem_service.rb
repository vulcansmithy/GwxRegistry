require 'base32'
require 'nem'

class NemService
  DEFAULT_NETWORK = Rails.env.production? ? "mainnet" : "testnet"

  NETWORKS = {
    TESTNET: '98',
    MAINNET: '68'
  }

  class << self
    def create_account(network = DEFAULT_NETWORK)
      private_key = SecureRandom.random_bytes(32)
      wallet = generate_wallet(private_key, network)
    end

    def check_balance(wallet_address)
      node = Nem::Node.new
      endpoint = Nem::Endpoint::Account.new(node)
      endpoint.find(wallet_address).balance.to_f / 1000000
    end

    private

    def to_hex(data)
      data.unpack('H*').first
    end

    def to_bin(data)
      [data].pack('H*')
    end

    def generate_wallet(private_key, network)
      pk = Ed25519.publickey(private_key.reverse)
      sha3_pk = to_bin(Digest::SHA3.hexdigest(pk, 256))
      rmd_pk = Digest::RMD160.hexdigest(sha3_pk)

      versioned_pk = NETWORKS[network.upcase.to_sym] + rmd_pk

      checksum = Digest::SHA3.hexdigest(to_bin(versioned_pk), 256)[0..7]
      bin_address = to_bin(versioned_pk + checksum)

      {
        priv_key: to_hex(private_key),
        pub_key: to_hex(pk),
        address: Base32.encode(bin_address)
      }
    end
  end
end
