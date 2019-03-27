require 'nem'
require 'securerandom'
# require_relative './ed25519.rb'
require 'base32'

class NemService
  def self.generate_account
    private_key = SecureRandom.random_bytes(32)
    pk = ED25519.publickey(private_key.reverse)
    hex_pk = to_hex(pk)
  end

  def to_hex(data)
    [data].unpack('H*').first
  end

  private

  def to_bin(data)
    [data].pack('H*')
  end

  def hash_rmd
    rmd_pk = Digest::RMD160.hexdigest(sha3_pk)
  end

  def mainnet
    versioned_pk = "98" + rmd_pk
  end

  def testnet
    versioned_pk = "68" + rmd_pk
  end

  def hash_sha3
    checksum = Digest::SHA3.hexdigest(to_bin(versioned_pk),256)[0..7]
  end

  def concat_result
    bin_address = to_bin(versioned_pk + checksum)
  end

  def encode_base32
    Base32.encode bin_address
>>>>>>> Creates wallet generation
  end
end
