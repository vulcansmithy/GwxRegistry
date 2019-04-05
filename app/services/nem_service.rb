require 'base32'
require 'nem'

class NemService
  attr_accessor :node, :account_endpoint

  DEFAULT_NETWORK = Rails.env.production? ? 'mainnet' : 'testnet'

  NETWORKS = {
    TESTNET: '98',
    MAINNET: '68'
  }

  NODE = Rails.env.production? ? 'hugealice3.nem.ninja' : 'bigalice2.nem.ninja'
  NAMESPACE = Rails.env.production? ? 'gameworks' : 'gameworkss'

  NEM_NODE = Nem::Node.new(host: NODE)
  ACCOUNT_ENDPOINT = Nem::Endpoint::Account.new(NEM_NODE)

  class << self
    def create_account(network = DEFAULT_NETWORK)
      private_key = SecureRandom.random_bytes(32)
      wallet = generate_wallet(private_key, network)
    end

    def check_balance(wallet_address)
      puts ">>>>>>>> Wallet Address: #{wallet_address}"
      xem = ACCOUNT_ENDPOINT.find(wallet_address).balance.to_f / 1000000
      puts ">>>>>>>>>>> XEM #{xem}"
      mosaic = ACCOUNT_ENDPOINT.mosaic_owned(wallet_address)
      puts ">>>>>>>>>>> Mosaic #{mosaic}"
      account = mosaic.find_by_namespace_id(NAMESPACE)
      puts ">>>>>>>>>>> account #{account}"

      if account.attachments.empty?
        puts ">>>>>>>>>>> attachments empty"
        { xem: xem }
      else
        puts ">>>>>>>>>>> attachemnts exists"
        gwx = account.attachments.first.quantity.to_f / 1000000
        puts ">>>>>>>>>>>>>>>>>> #{gwx}"
        { xem: xem,
          gwx: gwx }
      end
    end

    def unconfirmed_transactions(source_wallet, destination_wallet, mosaic_name = 'gwx')
      unconfirmed_transactions = ACCOUNT_ENDPOINT.transfers_unconfirmed(source_wallet)
      filter_by_destination = unconfirmed_transactions.select { |tx| tx.recipient == destination_wallet }
      total_quantity = nil

      if mosaic_name == 'xem'
        total_quantity = filter_by_destination.map(&:amount)
      else
        total_quantity = filter_by_destination.map do |tx|
          tx.mosaics.select { |mosaic| mosaic.name == mosaic_name }.first.quantity
        end
      end

      total_quantity.sum.to_f / 1000000
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
