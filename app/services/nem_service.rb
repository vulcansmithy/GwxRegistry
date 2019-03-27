# require 'nem'
# require 'securerandom'
require_relative './ed25519.rb'
require 'base32'
# require 'digest/sha3'

class NemService
  class << self
    def create
      private_key = to_hex(SecureRandom.random_bytes(32))
      puts('private_key: ', private_key)
      address = generate_wallet_address(private_key)
      puts('address: ', address)
    end

    private

    def to_hex(data)
      data.unpack1('H*')
    end

    def to_bin(data)
      [data].pack('H*')
    end
    
    def generate_wallet_address(private_key)
      pk = ED25519.publickey(private_key.reverse)
      sha3_pk = to_bin(Digest::SHA3.hexdigest(pk, 256))
      rmd_pk = Digest::RMD160.hexdigest(sha3_pk)
     
      # testnet wallet address
      versioned_pk = "98" + rmd_pk
      
      # mainnet wallet_address
      # versioned_pk = "68" + rmd_pk
      
      checksum = Digest::SHA3.hexdigest(to_bin(versioned_pk), 256)[0..7]
      bin_address = to_bin(versioned_pk + checksum)
      Base32.encode bin_address
    end
  end
end
