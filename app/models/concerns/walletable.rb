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
  
  def distribute_shards(wallet_address, shards)
=begin
    # define the url for the Cashier API create new Shard endpoint
    cashier_api_shard_endpoint = "#{ENV["CASHIER_URL"]}/shards"
    
    # prepare payload for the Cashier API
    body = {
      wallet_address: wallet_address,
      custodian_key: shards[1]
    }.to_json
    
    # call Cashier API and create a new Shard
    response = HTTParty.post(cashier_api_shard_endpoint,
      body: body,
      headers: {
        "Content-Type": "application/json"
      }
    )
    
    # make sure the response code is :created before continuing
    raise "Can't reach Cashier API." unless response.code == 201



    # define the url for the CustodianVault API create new Shard endpoint
    custodian_vault_api_shard_endpoint = "#{ENV["CUSTODIAN_VAULT_URL"]}/shards"
    
    # prepare payload for the CustodianVault API
    body = {
      wallet_address: wallet_address,
      custodian_key: shards[2]
    }.to_json
    
    # call CustodianVault API and create a new Shard
    response = HTTParty.post(custodian_vault_api_shard_endpoint,
      body: body,
      headers: {
        "Content-Type": "application/json"
      }
    )
    
    # make sure the response code is :created before continuing
    raise "Can't reach CustodianVault API." unless response.code == 201
=end
  end
  
  
end