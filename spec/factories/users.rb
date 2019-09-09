FactoryBot.define do

  factory :user, class: User do
    first_name            { Faker::Name.first_name }
    last_name             { Faker::Name.last_name  }
    email                 { "#{first_name}.#{last_name}@example.com".downcase }
    password              { "password"             }
    password_confirmation { "password"             }
    wallet_address        { Faker::Crypto.sha256   }
    username              { "#{first_name}#{last_name}".gsub(/[^0-9A-Za-z]/, '') }
  end

end
