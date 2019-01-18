require "rails_helper"

describe Api::V1::PublishersController do
  before do
    @user = create(:user)
  end

  it 'should implement the endpoint GET /publishers' do
    no_of_publishers = 5

    no_of_publishers.times do
      publisher = create(:publisher, user_id: @user.id)
    end

    get '/publishers'

    expect(response).to have_http_status(:ok)
    result = JSON.parse(response.body)

    expect(result["data"].length).to eq no_of_publishers
  end

  it 'should implement the endpoint GET /publishers/:user_id' do
    publisher = create(:publisher, user_id: @user.id)
    params = {
      publisher: {
        user_id: publisher.user_id
      }
    }.as_json

    get "/publishers/'#{publisher.user_id}'", params: params

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:ok)
    expect(result["data"]["id"].to_i).to eq publisher.id
  end

  it 'should implement the endpoint PATCH /publishers/:user_id' do
    publisher = create(:publisher, user_id: @user.id)
    publisher.publisher_name = "PROUDCLOUD"
    publisher_name = "Testing01"

    params = {
      publisher: {
        user_id: publisher.user_id,
        publisher_name: publisher_name,
        description: "hello world"
      }
    }.as_json

    patch "/publishers/'#{publisher.id}'", params: params

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:ok)
    expect(result["data"]["attributes"]["publisher_name"]).to eq publisher_name
  end

  it 'should implement the endpoint POST /publisher' do
    publisher_name = "PROUDCLOUD"
    params = {
      publisher: {
        user_id: @user.id,
        publisher_name: publisher_name,
        wallet_address: "123456",
        description: "hello"
      }
    }.as_json

    post "/publishers/", params: params

    result = JSON.parse(response.body)

    expect(response).to have_http_status(:created)
    expect(result["data"]["attributes"]["publisher_name"]).to eq publisher_name
  end

end
