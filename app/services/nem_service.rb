require 'base32'
require 'nem'

class NemService
  DEFAULT_NETWORK = Rails.env.production? ? 'mainnet' : 'testnet'

  NETWORKS = {
    TESTNET: '98',
    MAINNET: '68'
  }

  TIMEOUT = 15

  NEM_NODE =
    if Rails.env.production?
      Nem::NodePool.new([
        Nem::Node.new(host: '165.22.180.103', timeout: TIMEOUT),
        Nem::Node.new(host: '45.63.78.67', timeout: TIMEOUT),
        Nem::Node.new(host: '69.30.222.139', timeout: TIMEOUT),
        Nem::Node.new(host: '199.217.118.114', timeout: TIMEOUT),
        Nem::Node.new(host: '149.28.247.129', timeout: TIMEOUT),
        Nem::Node.new(host: '66.228.48.37', timeout: TIMEOUT),
        Nem::Node.new(host: '45.32.196.216', timeout: TIMEOUT),
        Nem::Node.new(host: '108.61.204.81', timeout: TIMEOUT),
        Nem::Node.new(host: '45.32.192.155', timeout: TIMEOUT),
        Nem::Node.new(host: '45.63.69.29', timeout: TIMEOUT),
        Nem::Node.new(host: '62.75.251.134', timeout: TIMEOUT),
        Nem::Node.new(host: '62.75.163.236', timeout: TIMEOUT),
        Nem::Node.new(host: '209.126.98.204', timeout: TIMEOUT),
        Nem::Node.new(host: '108.61.182.27', timeout: TIMEOUT),
        Nem::Node.new(host: '27.134.245.213', timeout: TIMEOUT),
        Nem::Node.new(host: '104.168.152.37', timeout: TIMEOUT),
        Nem::Node.new(host: '122.116.90.171', timeout: TIMEOUT),
        Nem::Node.new(host: '153.122.86.201', timeout: TIMEOUT),
        Nem::Node.new(host: '150.95.213.212', timeout: TIMEOUT),
        Nem::Node.new(host: '163.44.170.40', timeout: TIMEOUT),
        Nem::Node.new(host: '153.126.157.201', timeout: TIMEOUT),
        Nem::Node.new(host: '45.76.192.220', timeout: TIMEOUT)
      ])
    else
      Nem::NodePool.new([
        Nem::Node.new(host: '69.30.222.140', timeout: TIMEOUT),
        Nem::Node.new(host: '95.216.73.243', timeout: TIMEOUT),
        Nem::Node.new(host: '104.238.116.254', timeout: TIMEOUT),
        Nem::Node.new(host: '52.197.57.86', timeout: TIMEOUT),
        Nem::Node.new(host: '110.134.77.58', timeout: TIMEOUT),
        Nem::Node.new(host: '89.40.9.33', timeout: TIMEOUT),
        Nem::Node.new(host: '13.113.197.44', timeout: TIMEOUT),
        Nem::Node.new(host: '35.167.164.137', timeout: TIMEOUT),
        Nem::Node.new(host: '13.114.231.114', timeout: TIMEOUT),
        Nem::Node.new(host: '18.221.87.98', timeout: TIMEOUT),
        Nem::Node.new(host: '35.229.29.156', timeout: TIMEOUT),
        Nem::Node.new(host: '23.228.67.85', timeout: TIMEOUT),
        Nem::Node.new(host: '104.128.226.60', timeout: TIMEOUT),
        Nem::Node.new(host: '150.95.145.157', timeout: TIMEOUT),
        Nem::Node.new(host: '80.93.182.146', timeout: TIMEOUT),
        Nem::Node.new(host: '82.196.9.187', timeout: TIMEOUT),
        Nem::Node.new(host: '82.196.9.187', timeout: TIMEOUT),
        Nem::Node.new(host: '88.166.14.34', timeout: TIMEOUT)
      ])
    end

  NAMESPACE = Rails.env.production? ? 'gameworks' : 'gameworkss'

  class << self
    def create_account(network = DEFAULT_NETWORK)
      private_key = SecureRandom.random_bytes(32)
      wallet = generate_wallet(private_key, network)
    end

    def check_balance(wallet_address, mosaic_name = 'gwx')
      puts "@DEBUG L:#{__LINE__}  *********************"
      puts "@DEBUG L:#{__LINE__}  * Wallet Address: #{wallet_address}"
      puts "@DEBUG L:#{__LINE__}  *********************"
      account_endpoint = Nem::Endpoint::Account.new(NEM_NODE)
      xem = account_endpoint.find(wallet_address).balance.to_f / 1_000_000
      mosaic = account_endpoint.mosaic_owned(wallet_address)
      account = mosaic.find_by_namespace_id(NAMESPACE)

      if account.attachments.empty?
        { xem: xem }
      else
        gwx = account.attachments.select do |attachment|
          attachment.name == mosaic_name
        end.first.quantity.to_f / 1_000_000

        unconfirmed = account_endpoint.transfers_unconfirmed(wallet_address)

        puts "@DEBUG L:#{__LINE__}  *********************"
        puts "@DEBUG L:#{__LINE__}  * Unconfirmed Transactions: #{unconfirmed}"
        puts "@DEBUG L:#{__LINE__}  *********************"

        unconfirmed = (unconfirmed || []).select do |transaction|
                        transaction.mosaics.select do |m|
                          m.name == mosaic_name
                        end.present? if transaction.mosaics
                      end
        incoming = unconfirmed.select { |tx| tx.recipient == wallet_address }
        outgoing = unconfirmed - incoming

        total_incoming = incoming.map do |tx|
          tx.mosaics.select { |m| m.name == mosaic_name }.first.quantity
        end.sum.to_f / 1_000_000

        total_outgoing = outgoing.map do |tx|
          tx.mosaics.select { |m| m.name == mosaic_name }.first.quantity
        end.sum.to_f / 1_000_000

        current_gwx_balance = gwx + total_incoming - total_outgoing

        puts "@DEBUG L:#{__LINE__}   ***************************"
        puts "@DEBUG L:#{__LINE__}   *   XEM: #{xem}           *"
        puts "@DEBUG L:#{__LINE__}   *   GWX: #{gwx}           *"
        puts "@DEBUG L:#{__LINE__}   ***************************"

        {
          xem: xem,
          gwx: gwx,
          available_gwx: gwx,
          current_gwx_balance: current_gwx_balance,
          unconfirmed_incoming: total_incoming,
          unconfirmed_outgoing: total_outgoing
        }
      end
    end

    def wallet_transactions_for(source_wallet)
      account_endpoint = Nem::Endpoint::Account.new(NEM_NODE)
      account_endpoint.transfers_all(source_wallet).select do |tx|
        tx.mosaics.present? && tx.mosaics.map(&:name).include?('gwx')
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

    def check_game_balance(args)
      game_address = args[:game_address]
      wallet_address = args[:wallet_address]
      balance = check_balance(wallet_address)

      unconfirmed_bets = unconfirmed_transactions(
        wallet_address,
        game_address,
        'gwx'
      )

      unconfirmed_rewards = unconfirmed_transactions(
        game_address,
        wallet_address,
        'gwx'
      )

      available_balance = balance[:gwx] || 0
      current_balance = available_balance + unconfirmed_rewards - unconfirmed_bets

      {
        unconfirmed_bets: unconfirmed_bets,
        unconfirmed_rewards: unconfirmed_rewards,
        current_gwx_balance: current_balance,
        available_gwx: available_balance
      }.merge(balance)
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
