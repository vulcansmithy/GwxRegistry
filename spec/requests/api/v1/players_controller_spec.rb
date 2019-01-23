require "rails_helper"

describe Api::V1::PlayersController do

  it "should implement the endpoint GET /players" do
 
    # setup the no. of test players
    no_of_players = 5

    # setup test players to be returned
    no_of_players.times do
      user = create(:user)
      user.player = create(:player)
    end
    
    # call the API endpoint
    get "/players"

    # make sure the HTTP response code was returned :ok
    expect(response).to have_http_status(:ok)
    
    # retrieve the return data by the API endpoint
    result = JSON.parse(response.body)

    # make sure the no. of players matches to the set no_of_players
    expect(result["data"].length).to eq no_of_players
  end

  it "should implement the endpoint GET /players/:user_id" do

    # setup test player
    @user = create(:user)
    @user.player = create(:player)   
    player = @user.player

    # call the API endpoint
    get "/players/#{player.user_id}"

    # make sure the HTTP response code is :ok
    expect(response).to have_http_status(:ok)
        
    result = JSON.parse(response.body)
    puts "@DEBUG L:#{__LINE__}   #{ap result}"

    # make sure the result matches to the created test player
    expect(result["data"]["id"].to_i).to eq player.id
  end

  it "should be able to return 404 response code for GET /players/:user_id" do
    
    # call the API endpoint
    get "/players/999"
    
    # make sure the HTTP response code is :not_found
    expect(response).to have_http_status(:not_found)
  end

  it "should implement the endpoint PATCH/PUT /players/:user_id" do

    # setup test player 
    user = create(:user)
    user.player = create(:player)   
    player  = user.player
    user_id = user.id
    
    # setup a new name
    new_name = "leeroy.jenkins"
    
    params = {
      player: {
        username: new_name
      }
    }

    # call API endpoint
    patch "/players/#{player.user_id}", params: params
    
    # make sure the HTTP response code is :ok
    expect(response).to have_http_status(:ok)
    
    result = JSON.parse(response.body)
    puts "@DEBUG L:#{__LINE__}   #{ap result}"

    # make sure the 'username' was change to 'new_name'
    expect(result["data"]["attributes"]["username"]).to eq new_name
  end

  it "should implement the endpoint POST /players" do
    
    # setup test player 
    user = create(:user)

    username = "PROUDCLOUD"
    params = {
      player: {
        user_id:        user.id, 
        username:       username,
        wallet_address: Faker::Crypto.sha256 
      }
    }.as_json

    post "/players/", params: params

    # make sure the HTTP response code is :created
    expect(response).to have_http_status(:created)

    result = JSON.parse(response.body)
    puts "@DEBUG L:#{__LINE__}   #{ap result}"

    # make sure the Player actually exist
    expect(result["data"]["id"].to_i).to eq Player.first.id
  end

end
