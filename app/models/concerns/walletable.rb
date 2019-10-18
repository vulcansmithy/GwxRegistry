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
  
end