FactoryBot.define do

  factory :user, class: User do
    first_name      { Faker::Name.first_name }
    last_name       { Faker::Name.last_name  }
    email           { "#{first_name}.#{last_name}@example.com".downcase }
    password        { email                  }
    wallet_address  { Faker::Crypto.sha256   }
  end
  
end
