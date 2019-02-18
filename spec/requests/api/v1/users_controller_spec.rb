require "rails_helper"

describe Api::V1::UsersController do

  it "should implement the enpoint POST /login" do
    user = create(:user)

    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    expect(result["token"]).to_not eq nil
    expect(result["message"]).to eq "Login Successful"
  end

  it "should implement the endpoint GET /users" do

    # set the no. of Users accounts
    no_of_users = 5

    # setup 5 sample Users
    no_of_users.times do
      user = create(:user)
    end

    # retrieve the first User
    user = User.first

    # authenticate by calling the login endpoint
    post "/login", params: {email: user.email, password: "password"}

    # make sure the User was successfully login
    expect(response).to have_http_status(:ok)

    result = JSON.parse(response.body)

    # call the API endpoint
    get "/users", headers: { Authorization: "#{result["token"]}" }

    # make sure login was successful
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure the no_of_users matches
    expect(result["data"].length).to eq no_of_users
  end

  it "should implement the endpoint POST /register" do

    # setup test user information
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    email      = "#{first_name}.#{last_name}@example.com".downcase
    password   = email

    # setup parameters to pass
    params = {
      first_name: first_name,
      last_name:  last_name,
      email:      email,
      password:   password,
      password_confirmation: password
    }.as_json

    # call the API endpoint
    post "/users", params: params

    # make sure the response was :created
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure its a User type
    expect(result["user"]["data"]["type"]).to eq "user"

    # make sure the result have the same email
    expect(result["user"]["data"]["attributes"]["email"]).to eq email
  end

  it "should implement the endpoint GET users/:id" do
    # setup test user
    user = create(:user)

    post "/login", params: { email: user.email, password: "password" }
    result = JSON.parse(response.body)

    # call the API endpoint
    get "/users/#{user.id}", headers: {Authorization: "#{result["token"]}"}

    # make sure the response was :ok
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure the response has the same info as the test user
    expect(result["data"]["attributes"]["email"]).to eq user.email
  end

  it "should implement the endpoint PATCH/PUT /users/:id" do

    # setup test user
    user = create(:user)

    post "/login", params: {email: user.email, password: "password"}
    result = JSON.parse(response.body)

    # setup a new test user first_name and last_name
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    wallet_address = Faker::Number.hexadecimal(20)
    pk = Faker::Number.hexadecimal(10)

    # setup parameters to pass
    params = {
      first_name: first_name,
      last_name:  last_name,
      wallet_address: wallet_address,
      pk: pk
    }.as_json

    # call the API endpoint
    patch "/users/#{user.id}", params: params, headers: {Authorization: "#{result["token"]}"}

    # make sure the response was :ok
    expect(response).to have_http_status(:ok)

    # retrieve the result
    result = JSON.parse(response.body)

    # make sure the first_name was successfully updated
    expect(result["data"]["attributes"]["first_name"]).to eq first_name

    # make sure the first_name was successfully updated
    expect(result["data"]["attributes"]["last_name"]).to eq last_name
  end
 end
