# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#
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
