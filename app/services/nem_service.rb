require 'base32'
require 'nem'

class NemService
  DEFAULT_NETWORK = Rails.env.production? ? 'mainnet' : 'testnet'

  NETWORKS = {
    TESTNET: '98',
    MAINNET: '68'
  }

  NEM_NODE =
    if Rails.env.production?
      Nem::NodePool.new([
        Nem::Node.new(host: '62.75.251.134', timeout: 15),
        Nem::Node.new(host: '62.75.163.236', timeout: 15),
        Nem::Node.new(host: '209.126.98.204', timeout: 15),
        Nem::Node.new(host: '108.61.182.27', timeout: 15),
        Nem::Node.new(host: '27.134.245.213', timeout: 15),
        Nem::Node.new(host: '104.168.152.37', timeout: 15),
        Nem::Node.new(host: '122.116.90.171', timeout: 15),
        Nem::Node.new(host: '153.122.86.201', timeout: 15),
        Nem::Node.new(host: '150.95.213.212', timeout: 15),
        Nem::Node.new(host: '163.44.170.40', timeout: 15),
        Nem::Node.new(host: '153.126.157.201', timeout: 15),
        Nem::Node.new(host: '45.76.192.220', timeout: 15)
      ])
    else
      Nem::NodePool.new([
        Nem::Node.new(host: '23.228.67.85'),
        Nem::Node.new(host: '104.128.226.60'),
        Nem::Node.new(host: '150.95.145.157'),
        Nem::Node.new(host: '80.93.182.146'),
        Nem::Node.new(host: '82.196.9.187'),
        Nem::Node.new(host: '82.196.9.187'),
        Nem::Node.new(host: '88.166.14.34')
      ])
    end

  NAMESPACE = Rails.env.production? ? 'gameworks' : 'gameworkss'

  class << self
    def create_account(network = DEFAULT_NETWORK)
      private_key = SecureRandom.random_bytes(32)
      wallet = generate_wallet(private_key, network)
    end

    def check_balance(wallet_address)
      account_endpoint = Nem::Endpoint::Account.new(NEM_NODE)
      xem = account_endpoint.find(wallet_address).balance.to_f / 1000000
      mosaic = account_endpoint.mosaic_owned(wallet_address)
      account = mosaic.find_by_namespace_id(NAMESPACE)

      if account.attachments.empty?
        { xem: xem }
      else
        gwx = account.attachments.first.quantity.to_f / 1000000
        { xem: xem,
          gwx: gwx }
      end
    end

    def unconfirmed_transactions(source_wallet, destination_wallet, mosaic_name = 'gwx')
      account_endpoint = Nem::Endpoint::Account.new(NEM_NODE)
      unconfirmed_transactions = account_endpoint.transfers_unconfirmed(source_wallet)
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
