namespace :sharding do
  
  namespace :test do
    
    desc 'Say hello!'
    task :split_and_distribute do
      puts "Hello"
      test_wallet = [
        "TAUBFB4SLR3RVNKDJJ3XSJ2HOZAS3IVE3KTFPPAW",
        "TAANF5SJOPLNFK5UVQGSEVKYWJBIHPCBZAOURTIM",
        "TAWGRADGYXNMWJMNA23T4QJUX4XYJATVL6ZC7ZGI",
        "TAAXFSHF7KNSWWVGOPR3VTKMGVLI2R4QBH46JOAE",
        "TBRMH7ROI6JTJE3PPHKKSZNO322QJFARLWE3CR3Q"
      ].each do |wallet_address|
        puts "@DEBUG L:#{__LINE__}   #{wallet_address}"
      end
    end

  end  

  namespace :staging do
  end 
  
  namespace :production do
  end    

end  