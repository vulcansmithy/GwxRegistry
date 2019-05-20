FactoryBot.define do
  factory :game, class: Game do
    publisher
    name { Faker::Name.name }
    description { Faker::Lorem.sentence }
  end
end
