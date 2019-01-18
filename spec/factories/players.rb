FactoryBot.define do

  factory :player do
    username { Faker::Name.unique.name }
    wallet_address { Faker::Number.number(20) }
  end

end
