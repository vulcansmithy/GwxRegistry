FactoryBot.define do
  factory :application, class: Doorkeeper::Application do
    name { Faker::Name.first_name }
    redirect_uri { 'urn:ietf:wg:oauth:2.0:oob' }
    association :owner, factory: :user
  end
end
