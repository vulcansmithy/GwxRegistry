FactoryBot.define do
  factory :player_profile, class: PlayerProfile do
    user
    game
    username { "#{user.first_name}#{user.last_name}".gsub(/[^0-9A-Za-z]/, '') }
  end
end
