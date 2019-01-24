require "rails_helper"

describe Api::V1::PlayersController do

  xit "should implement the endpoint GET /players" do
 
    # setup the no. of test players
    no_of_players = 5

    # setup test players to be returned
    no_of_players.times do
      player = create(:player, user: create(:user))
    end
    
    # call the API endpoint
    get "/players"

    # make sure the HTTP response code was returned :ok
    expect(response).to have_http_status(:ok)
    
    # retrieve the return data by the API endpoint
    result = JSON.parse(response.body)
    puts "@DEBUG L:#{__LINE__}   #{ap result}"

    # make sure the no. of players matches to the set no_of_players
    expect(result["data"].length).to eq no_of_players
  end

  xit "should implement the endpoint GET /players/:user_id" do

    # setup a test player
    player = create(:player, user: create(:user))

    # call the API endpoint
    get "/players/#{player.user_id}"

    # make sure the HTTP response code was returned :ok
    expect(response).to have_http_status(:ok)
        
    # retrieve the return data by the API endpoint    
    result = JSON.parse(response.body)
    puts "@DEBUG L:#{__LINE__}   #{ap result}"

    # make sure the result matches to the created test player
    expect(result["data"]["id"].to_i).to eq player.id
  end

  xit "should be able to return 404 response code for GET /players/:user_id" do
    
    # call the API endpoint
    get "/players/999"
    
    # make sure the HTTP response code was :not_found
    expect(response).to have_http_status(:not_found)
  end

  xit "should implement the endpoint PATCH/PUT /players/:user_id" do

    # setup test player 
    player  = create(:player, user: create(:user))
    user_id = player.user_id
    
    # setup a new name
    new_username = "leeroy.jenkins"
    
    # prepare the params to be passed
    params = {
      player: {
        username: new_username
      }
    }

    # call the API endpoint
    patch "/players/#{player.user_id}", params: params
    
    # make sure the HTTP response code was returned :ok
    expect(response).to have_http_status(:ok)
    
    # retrieve the return data by the API endpoint    
    result = JSON.parse(response.body)
    puts "@DEBUG L:#{__LINE__}   #{ap result}"

    # make sure the 'username' was change to the new username
    expect(result["data"]["attributes"]["username"]).to eq new_username
  end

  it "should implement the endpoint POST /players" do
    
    # setup test player 
    user = create(:user)

    # prepare the params to be passed
    username = Faker::Internet.user_name 
    params   = {
      player: {
        user_id:        user.id, 
        username:       username,
        wallet_address: Faker::Crypto.sha256 
      }
    }.as_json

    # call the API endpoint
    post "/players/", params: params

    # make sure the HTTP response code was returned :created
    expect(response).to have_http_status(:created)

    # retrieve the return data by the API endpoint   
    result = JSON.parse(response.body)
    puts "@DEBUG L:#{__LINE__}   #{ap result}"

    # make sure the Player actually exist
    expect(result["data"]["id"].to_i).to eq Player.first.id
  end

end
