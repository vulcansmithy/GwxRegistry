FactoryBot.define do

  factory :player do
    username        { Faker::Internet.user_name }
    wallet_address  { Faker::Crypto.sha256      }
  end
  
end
