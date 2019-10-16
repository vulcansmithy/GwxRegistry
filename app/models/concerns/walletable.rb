module Walletable
  extend ActiveSupport::Concern

  included do
    include WalletPkSecurity::Splitter
  end
    
  private

  def create_account
    account = NemService.create_account
    result  = split_up_and_distribute(account[:address], account[:priv_key])
    self.create_wallet(
      wallet_address: account[:address],
      pk: account[:priv_key],
      custodian_key: result[:shards][0]
    )
  end
  
  # @TODO
  def distribute_shards(wallet_address, shards)
    puts "@DEBUG L:#{__LINE__}   wallet_address: #{wallet_address}"
    puts "@DEBUG L:#{__LINE__}        shards[1]:#{shards[1]}"
    puts "@DEBUG L:#{__LINE__}        shards[2]:#{shards[2]}"
  end
end