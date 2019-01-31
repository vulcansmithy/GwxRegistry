require "rails_helper"

describe Api::V1::UsersController do

  it "should implement the endpoint GET /users" do

    # set the no. of Users accounts
    no_of_users = 5

    # setup 5 sample Users
    no_of_users.times do
      user = create(:user)
    end

    user = User.first
    post "/users/login", params: {email: user.email, password: "password"}
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/users", headers: { Authorization: "#{result["access_token"]}" }

    # make sure login was successful
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure the no_of_users matches
    expect(result["data"].length).to eq no_of_users
  end

=begin
  xit "should implement the endpoint POST /users" do

    # setup test user information
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    email      = "#{first_name}.#{last_name}@example.com".downcase
    password   = email

    # setup parameters to pass
    params = {
      user: {
        first_name: first_name,
        last_name:  last_name,
        email:      email,
        password:   password,
        password_confirmation: password
      }
    }.as_json

    # call the API endpoint
    post "/users", params: params

    # make sure the response was :created
    expect(response).to have_http_status(:created)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure its a User type
    expect(result["data"]["type"]).to eq "user"

    # make sure the result have the same email
    expect(result["data"]["attributes"]["email"]).to eq email
  end

  xit "should implement the endpoint GET users/:id" do
    # setup test user
    user = create(:user)

    post "/users/login", params: {email: user.email, password: "password"}
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/users/#{user.id}", headers: {Authorization: "#{result["access_token"]}"}

    # make sure the response was :ok
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure the response has the same info as the test user
    expect(result["data"]["attributes"]["email"]).to eq user.email
  end

  xit "should implement the endpoint PATCH/PUT /users/profile_update/:id" do

    # setup test user
    user = create(:user)

    post "/users/login", params: {email: user.email, password: "password"}
    result = JSON.parse(response.body)

    # setup a new test user first_name and last_name
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name

    # setup parameters to pass
    params = {
      user: {
        first_name: first_name,
        last_name:  last_name
      }
    }.as_json

    # call the API endpoint
    patch "/users/profile_update/#{user.id}", params: params, headers: {Authorization: "#{result["access_token"]}"}

    # make sure the response was :ok
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure the first_name was successfully updated
    expect(result["data"]["attributes"]["first_name"]).to eq first_name

    # make sure the first_name was successfully updated
    expect(result["data"]["attributes"]["last_name"]).to eq last_name
  end

  xit "should implement the endpoint PATCH/PUT /users/account_update/:id" do

    # setup test user
    user = create(:user)

    post "/users/login", params: {email: user.email, password: "password"}
    result = JSON.parse(response.body)

    # setup a new test user email
    email = "#{user.first_name}.#{user.last_name}+#{Faker::Lorem.word}@example.com".downcase

    # setup parameters to pass
    params = {
      user: {
        email:    email,
        password: email,
        password_confirmation: email
      }
    }.as_json

    # call the API endpoint
    patch "/users/account_update/#{user.id}", params: params, headers: {Authorization: "#{result["access_token"]}"}

    # make sure the response was :ok
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure the first_name was successfully updated
    expect(result["data"]["attributes"]["email"]).to eq email
  end
=end
end
