FactoryBot.define do

  factory :user, class: User do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name  }
    email      { "#{first_name.downcase}.#{last_name.downcase}@example.com" }
    password   { email                  }
  end

end
