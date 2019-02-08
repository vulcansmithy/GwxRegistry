namespace :create_users do
  task :users => :environment do
    puts "\n How many users should we create?"
    answer = STDIN.gets.chomp


    1..answer.to_i.times do |i|
      user = User.create!(first_name: "test#{i}",
                         last_name: "user",
                         email: "test_user#{i}@sample.com",
                         password: "password",
                         wallet_address: "TCP33TIK2FSSFWXUIBHWXNUZDGISPTCZE5YSSTJW")

    end
  end

  task :players => :environment do
    User.all.each do |user|
      user.create_player(username: "player_#{user.first_name}")
    end
  end

  task :publishers => :environment do
    User.all.each do |user|
      user.create_publisher(publisher_name: "publisher_#{user.first_name}",
                           wallet_address: "TB52BO2NECER6ZJSNZM6AUTYXNCT53KLZBNI4Z32")
    end
  end
end
