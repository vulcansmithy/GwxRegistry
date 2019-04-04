require "rails_helper"

describe Api::V2::PublishersController do

  xit "should implement the endpoint GET /publishers" do

    # set the no. of Publisher profile
    no_of_publishers = 5

    # setup 5 sample test Publishers
    no_of_publishers.times do
      publisher = create(:publisher, user: create(:user))
    end

    # retrieve the first User
    user = User.first

    # authenticate by calling the login endpoint
    post "/login", params: { email: user.email, password: "password" }

    # make sure the User was successfully login
    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    # call the API endpoint
    get "/publishers", headers: { Authorization: "#{result['token']}" }

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"].length).to eq no_of_publishers
  end

  it "should implement the endpoint GET /publishers/:userId" do
    publisher = create(:publisher, user: create(:user))

    post "/login", params: { email: publisher.user.email, password: "password" }
    result = JSON.parse(response.body)

    get "/publishers/#{publisher.user_id}", headers: { Authorization: "#{result['token']}" }

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"]["id"].to_i).to eq publisher.id
  end

  it "should be able to return 404 response code for GET /publishers/:userId" do
    user = create(:user)

    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/publishers/999", headers: { Authorization: "#{result['token']}" }

    # make sure the HTTP response code was :not_found
    expect(response).to have_http_status(:not_found)
  end

  it "should be able to return user not found error for GET /publishers/:userId with wrong access_token" do

    publisher = create(:publisher, user: create(:user))

    post "/login", params: { email: publisher.user.email, password: "password" }

    # pass an incorrect access token
    get "/publishers/#{publisher.user_id}", headers: { Authorization: "incorect-token" }

    result = JSON.parse(response.body)

    # make sure the HTTP response code was :unauthorized
    expect(response).to have_http_status(:unauthorized)
  end

  it "should implement the endpoint PATCH/PUT /publishers/:userId" do
    publisher = create(:publisher, user: create(:user))
    new_name = "Testing01"

    post '/login', params: {email: publisher.user.email, password: 'password'}
    result = JSON.parse(response.body)

    params = {
      publisherName: new_name,
    }.as_json

    patch "/publishers/#{publisher.user_id}", params: params, headers: { Authorization: "#{result['token']}" }

    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    expect(result["data"]["attributes"]["publisherName"]).to eq new_name
  end

  it "should implement the endpoint POST /publisher" do
    user = create(:user)

    post '/login', params: {email: user.email, password: 'password'}
    result = JSON.parse(response.body)

    params = {
      userId:        user.id,
      publisherName: "PROUDCLOUD",
      walletAddress: Faker::Crypto.sha256,
      description:    "hello"
    }.as_json

    post "/publishers/", params: params, headers: { Authorization: "#{result['token']}" }

    expect(response).to have_http_status(:created)

    result = JSON.parse(response.body)

    expect(result["data"]["id"].to_i).to eq Publisher.first.id
  end

end
