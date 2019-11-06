require "sssa"

namespace :sharding do
  
  namespace :test do
    
    desc "Run a test Wallet pk sharding and distribution"
    task :split_and_distribute do

      test_wallet = [
        "TAUBFB4SLR3RVNKDJJ3XSJ2HOZAS3IVE3KTFPPAW",
        "TAANF5SJOPLNFK5UVQGSEVKYWJBIHPCBZAOURTIM",
        "TAWGRADGYXNMWJMNA23T4QJUX4XYJATVL6ZC7ZGI",
        "TAAXFSHF7KNSWWVGOPR3VTKMGVLI2R4QBH46JOAE",
        "TBRMH7ROI6JTJE3PPHKKSZNO322QJFARLWE3CR3Q"
      ].each do |wallet_address|
        queried_result = Wallet.where(wallet_address: wallet_address)
        unless queried_wallet.empty?
          target_wallet = queried_result.first
          result = split_up_and_distribute(wallet_address, target_wallet.pk)
          target_wallet.custodian_key = result[:shards][0]
          
          raise "Target wallet with the address '#{wallet_address}' can't be save."unless target_wallet.save
        end  
      end
    end

  end  

  namespace :staging do
  end 
  
  namespace :production do
  end  
  
  def split_up_and_distribute(wallet_address, wallet_pk, min_shares_to_work=2, max_shares_allowed=3)
    
    result = nil
    begin
      # make sure the passed 'wallet_address' is neither nil or empty
      raise "wallet_address' was nil or empty." if wallet_address.nil? || wallet_address.empty?
    
      # make sure the passed 'wallet_pk' is neither nil or empty
      raise "'wallet_pk' was nil or empty." if wallet_pk.nil? || wallet_pk.empty? 

      # using SSSA split up the wallet_pk into individual shares or shards
      shards = SSSA::create(min_shares_to_work, max_shares_allowed, wallet_pk)

      puts ":#{__LINE__}   wallet_address: #{wallet_address}"
      puts ":#{__LINE__}        wallet_pk: #{wallet_pk     }"
      puts ":#{__LINE__}   #{ap shards}" 

      distribute_shards(wallet_address, shards)  

    rescue Exception => e
      result = { success: false, message: e.message }
    else
      result = { success: true }
      
      # only going to run when running in Development or Test environment
      result.merge!({ shards: shards }) unless Rails.env.production?
    ensure
      return result
    end
  end

  def distribute_shards(wallet_address, shards)
    
    if Rails.env.staging?
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
      
    elsif Rails.env.development?
      puts "@DEBUG L:#{__LINE__}   Sending out to CustodianVault the shard... '#{shards[1]}'"
      puts "@DEBUG L:#{__LINE__}   Sending out to Cashier API the shard...... '#{shards[2]}'"
    end  

  end
end  