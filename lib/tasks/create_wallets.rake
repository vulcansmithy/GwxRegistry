namespace :create_wallets do
  task :users => :environment do
    User.all.each do |user|
      unless user.wallet
        user.create_wallet(
          wallet_address: user.wallet_address,
          encrypted_pk: user.encrypted_pk,
          encrypted_pk_iv: user.encrypted_pk_iv
        )
      end
    end
  end
end
