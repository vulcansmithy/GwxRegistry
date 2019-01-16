require "rails_helper"

describe Api::V1::UsersController do

  it "should implement the endpoint GET /users" do
    
    # set the no. of Users accounts
    no_of_users = 5
    
    # setup 5 sample Users
    no_of_users.times do
      user = create(:user)
    end
    
    # call the API endpoint
    get "/users"
    
    # make sure login was successful
    expect(response).to have_http_status(:ok)
    
    # make sure the no_of_users matches
    expect(JSON.parse(response.body).length).to eq no_of_users
  end 
  
  it "should implement the endpoint POST /users" do
    
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
  end 
end
