FactoryBot.define do

  factory :publisher, class: Publisher do
    user           # define User association
    description    { Faker::Lorem.sentence   }
    wallet_address { Faker::Crypto.sha256    }
    publisher_name { Faker::Name.unique.name }
  end
end
