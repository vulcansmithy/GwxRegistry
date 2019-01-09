FactoryBot.define do

  factory :publisher, class: Publisher do
    user        # define User association
    description { Faker::Lorem.sentence } 
  end
  
end
