1..5.times do |i|
  user = User.create!(first_name: "test_#{i}",
                      last_name: "sample",
                      email: "test_user#{i}@sample.com",
                      password: "password",
                      password_confirmation: "password",
                      wallet_address: "TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW")
  user.create_publisher(publisher_name: "test_publisher_#{i}",
                        wallet_address: "TB52BO2NECER6ZJSNZM6AUTYXNCT53KLZBNI4Z32")
end
game = Publisher.last.games.create(name: "space invaders", description: "shooting game")
action = game.actions.create(name: 'Action 1', description: 'Action Description 1', fixed_amount: 150.0, unit_fee: 1, fixed: true, rate: false)
player_profile = User.last.player_profiles.create(username: "player", game_id: game.id)
  