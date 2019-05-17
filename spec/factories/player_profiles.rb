FactoryBot.define do
  factory :player_profile do
    user
    game
    username { "#{user.first_name}.#{user.last_name}".downcase }
  end
end
