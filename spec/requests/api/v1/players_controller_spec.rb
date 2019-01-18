require "rails_helper"

describe Api::V1::PlayersController do
  before do
    @user = create(:user)
  end

  it 'should implement the endpoint GET /players' do
    no_of_players = 5

    no_of_players.times do
      player = create(:player, user_id: @user.id)
    end

    get '/players'

    expect(response).to have_http_status(:ok)
    result = JSON.parse(response.body)

    expect(result["data"].length).to eq no_of_players
  end

  it 'should implement the endpoint GET /players/:user_id' do
    player = create(:player, user_id: @user.id)
    params = {
      player: {
        user_id: player.user_id
      }
    }.as_json

    get "/players/'#{player.user_id}'", params: params

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:ok)
    expect(result["data"]["id"].to_i).to eq player.id
  end

  it 'should implement the endpoint PATCH /players/:user_id' do
    player = create(:player, user_id: @user.id)
    player.username = "PROUDCLOUD"
    username = "Testing01"

    params = {
      player: {
        user_id: player.user_id,
        username: username
      }
    }.as_json

    patch "/players/'#{player.id}'", params: params

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:ok)
    expect(result["data"]["attributes"]["username"]).to eq username
  end

  it 'should implement the endpoint POST /players' do
    username = "PROUDCLOUD"
    params = {
      player: {
        user_id: @user.id,
        username: username,
        wallet_address: "123456"
      }
    }.as_json

    post "/players/", params: params

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:created)
    expect(result["data"]["attributes"]["username"]).to eq username
  end

end
