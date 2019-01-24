FactoryBot.define do

  factory :player do
    user           # define User association
    username       { "#{user.first_name}.#{user.last_name}".downcase }
    wallet_address { Faker::Crypto.sha256 }
  end
  
end
