require "rails_helper"

describe Api::V1::PlayersController do

  xit "should implement the endpoint GET /players" do

    # setup the no. of test players
    no_of_players = 5

    # setup test players to be returned
    no_of_players.times do
      player = create(:player, user: create(:user))
    end

    user = User.first
    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/players", headers: { Authorization: "#{result['token']}" }

    # make sure the HTTP response code was returned :ok
    expect(response).to have_http_status(:ok)

    # retrieve the return data by the API endpoint
    result = JSON.parse(response.body)

    # make sure the no. of players matches to the set no_of_players
    expect(result["data"].length).to eq no_of_players
  end

  it "should implement the endpoint GET /players/:userId" do

    # setup a test player
    player = create(:player, user: create(:user))

    post "/login", params: { email: player.user.email, password: "password" }
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/players/#{player.user_id}", headers: { Authorization: "#{result['token']}" }

    # make sure the HTTP response code was returned :ok
    expect(response).to have_http_status(:ok)

    # retrieve the return data by the API endpoint
    result = JSON.parse(response.body)

    # make sure the result matches to the created test player
    expect(result["data"]["id"].to_i).to eq player.id
  end

  it "should be able to return 404 response code for GET /players/:userId" do

    user = create(:user)

    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/players/999", headers: { Authorization: "#{result['token']}" }

    # make sure the HTTP response code was :not_found
    expect(response).to have_http_status(:not_found)
  end

  it "should implement the endpoint PATCH/PUT /players/:user_id" do

    # setup test player
    player  = create(:player, user: create(:user))
    userId = player.user_id

    post "/login", params: {email: player.user.email, password: "password" }
    result = JSON.parse(response.body)

    # setup a new name
    new_username = "leeroy.jenkins"

    # prepare the params to be passed
    params = {
      username: new_username
    }

    # call the API endpoint
    patch "/players/#{player.user_id}", params: params, headers: { Authorization: "#{result['token']}" }

    # make sure the HTTP response code was returned :ok
    expect(response).to have_http_status(:ok)

    # retrieve the return data by the API endpoint
    result = JSON.parse(response.body)

    # make sure the 'username' was change to the new username
    expect(result["data"]["attributes"]["username"]).to eq new_username
  end

  it "should implement the endpoint POST /players" do

    # setup test player
    user = create(:user)

    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    # prepare the params to be passed
    params = {
      userId:        user.id,
      username:       "PROUDCLOUD",
      walletAddress: Faker::Crypto.sha256
    }.as_json

    # call the API endpoint
    post "/players/", params: params, headers: { Authorization: "#{result['token']}" }

    # make sure the HTTP response code was returned :created
    expect(response).to have_http_status(:created)

    # retrieve the return data by the API endpoint
    result = JSON.parse(response.body)

    # make sure the Player actually exist
    expect(result["data"]["id"].to_i).to eq Player.first.id
  end

end
