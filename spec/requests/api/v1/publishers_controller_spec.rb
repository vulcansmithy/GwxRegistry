require "rails_helper"

describe Api::V1::PublishersController do

  it 'should implement the endpoint GET /publishers' do
    no_of_publishers = 5

    no_of_publishers.times do
      publisher = create(:publisher, user: create(:user))
    end

    get '/publishers'

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"].length).to eq no_of_publishers
  end

  it 'should implement the endpoint GET /publishers/:user_id' do
    publisher = create(:publisher, user: create(:user))

    get "/publishers/#{publisher.user_id}"

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"]["id"].to_i).to eq publisher.id
  end

  it "should be able to return 404 response code for GET /publishers/:user_id" do

    # call the API endpoint
    get "/publishers/999"

    # make sure the HTTP response code was :not_found
    expect(response).to have_http_status(:not_found)
  end

  it 'should implement the endpoint PATCH/PUT /publishers/:user_id' do
    publisher = create(:publisher, user: create(:user))
    new_name = "Testing01"

    params = {
      publisher: {
        publisher_name: new_name,
      }
    }.as_json

    patch "/publishers/#{publisher.user_id}", params: params

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"]["attributes"]["publisher_name"]).to eq new_name
  end

  it 'should implement the endpoint POST /publisher' do
    user = create(:user)

    params = {
      publisher: {
        user_id:        user.id,
        publisher_name: "PROUDCLOUD",
        wallet_address: Faker::Crypto.sha256,
        description:    "hello"
      }
    }.as_json

    post "/publishers/", params: params

    expect(response).to have_http_status(:created)

    result = JSON.parse(response.body)

    expect(result["data"]["id"].to_i).to eq Publisher.first.id
  end

end
