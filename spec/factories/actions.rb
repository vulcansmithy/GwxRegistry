FactoryBot.define do
  factory :action, class: Action do
    game
    name { Faker::Name.first_name }
    description { Faker::Lorem.sentence }
    fixed_amount { 150 }
    unit_fee { 1 }
    fixed { true }
    rate { false }
  end
end
