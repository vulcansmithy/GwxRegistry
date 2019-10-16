require "sssa"

module WalletPkSecurity

  module Splitter
    def split_up_and_distribute(wallet_address, wallet_pk, min_shares_to_work=2, max_shares_allowed=3)
      
      result = nil
      begin
        # make sure the passed 'wallet_address' is neither nil or empty
        raise "wallet_address' was nil or empty." if wallet_address.nil? || wallet_address.empty?
      
        # make sure the passed 'wallet_pk' is neither nil or empty
        raise "'wallet_pk' was nil or empty." if wallet_pk.nil? || wallet_pk.empty? 

        # using SSSA split up the wallet_pk into individual shares or shards
        shards = SSSA::create(min_shares_to_work, max_shares_allowed, wallet_pk)
        unless Rails.env.production?
          puts ":#{__LINE__}   wallet_address: #{wallet_address}"
          puts ":#{__LINE__}        wallet_pk: #{wallet_pk     }"
          puts ":#{__LINE__}   #{ap shards}" 
        end  

        # programmatically call hook method that distributes the shards
        method_to_call = "distribute_shards"
        if self.respond_to?(method_to_call, true)
          self.send(method_to_call, wallet_address, shards)
        else
          raise "Missing expected '#{method_to_call}' method."
        end    

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
  end # Splitter module
  
  module Combiner
    
    def combine_and_rebuild_wallet_pk(shards)
      wallet_pk = SSSA::combine(shards)
      
      return wallet_pk
    end # combine_and_rebuild_wallet_pk 
    
  end # Combiner module

end # WalletPkSecurity module