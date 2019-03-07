1..5.times do |i|
  user = User.create!(first_name: "test_#{i}",
                      last_name: "sample",
                      email: "test_user#{i}@sample.com",
                      password: "password",
                      wallet_address: "TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW")

  user.create_player(username: "player#{i}")
  user.create_publisher(publisher_name: "test_publisher_#{i}",
                        wallet_address: "TB52BO2NECER6ZJSNZM6AUTYXNCT53KLZBNI4Z32")
end
