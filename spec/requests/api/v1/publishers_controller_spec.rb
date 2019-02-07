require "rails_helper"

describe Api::V1::PublishersController do

  it "should implement the endpoint GET /publishers" do
    
    # set the no. of Publisher profile
    no_of_publishers = 5

    # setup 5 sample test Publishers
    no_of_publishers.times do
      publisher = create(:publisher, user: create(:user))
    end

    # retrieve the first User
    user = User.first
    
    # authenticate by calling the login endpoint
    post "/users/login", params: { email: user.email, password: "password" }
    
    # make sure the User was successfully login
    expect(response).to have_http_status(:ok)
    
    result = JSON.parse(response.body)
    
    # call the API endpoint
    get "/publishers", headers: { Authorization: "#{result['access_token']}" }

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"].length).to eq no_of_publishers
  end

  it "should implement the endpoint GET /publishers/:user_id" do
    publisher = create(:publisher, user: create(:user))

    post "/users/login", params: { email: publisher.user.email, password: "password" }
    result = JSON.parse(response.body)

    get "/publishers/#{publisher.user_id}", headers: { Authorization: "#{result['access_token']}" }

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"]["id"].to_i).to eq publisher.id
  end

  it "should be able to return 404 response code for GET /publishers/:user_id" do
    user = create(:user)

    post "/users/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/publishers/999", headers: { Authorization: "#{result['access_token']}" }

    # make sure the HTTP response code was :not_found
    expect(response).to have_http_status(:not_found)
  end

  it "should be able to return user not found error for GET /publishers/:user_id with wrong access_token" do

    publisher = create(:publisher, user: create(:user))

    post "/users/login", params: { email: publisher.user.email, password: "password" }

    # pass an incorrect access token
    get "/publishers/#{publisher.user_id}", headers: { Authorization: "incorect-token" }
    
    result = JSON.parse(response.body)

    # make sure the HTTP response code was :unauthorized
    expect(response).to have_http_status(:internal_server_error)
  end

  it "should implement the endpoint PATCH/PUT /publishers/:user_id" do
    publisher = create(:publisher, user: create(:user))
    new_name = "Testing01"

    post '/users/login', params: {email: publisher.user.email, password: 'password'}
    result = JSON.parse(response.body)

    params = {
      publisher: {
        publisher_name: new_name,
      }
    }.as_json

    patch "/publishers/#{publisher.user_id}", params: params, headers: { Authorization: "#{result['access_token']}" }

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"]["attributes"]["publisher_name"]).to eq new_name
  end

  it "should implement the endpoint POST /publisher" do
    user = create(:user)

    post '/users/login', params: {email: user.email, password: 'password'}
    result = JSON.parse(response.body)

    params = {
      publisher: {
        user_id:        user.id,
        publisher_name: "PROUDCLOUD",
        wallet_address: Faker::Crypto.sha256,
        description:    "hello"
      }
    }.as_json

    post "/publishers/", params: params, headers: { Authorization: "#{result['access_token']}" }

    expect(response).to have_http_status(:created)

    result = JSON.parse(response.body)

    expect(result["data"]["id"].to_i).to eq Publisher.first.id
  end

end
