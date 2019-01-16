require "rails_helper"

describe Api::V1::UsersController do

  xit "should implement the endpoint GET /users" do
    
    # setup 5 sample Users
    5.times do
      user = create(:user)
    end
    
    # call the API endpoint
    get "/users"
    
    # make sure login was successful
    expect(response).to have_http_status(:ok)
  end 
  
  it "should implement the endpoint POST /users" do
    
    first_name = Faker::Name.first_name
    last_name  = Faker::Name.last_name
    email      = "#{first_name}.#{last_name}@example.com".downcase
    password   = email
    parameters = {
      "user" => {
        "first_name" => first_name,
        "last_name"  => last_name,
        "email"      => email,
        "password"   => password  
      }
    }
    
    # call the API endpoint
    post "/users", params: parameters
    
    # make sure the response was :created
    expect(response).to have_http_status(:created)
  end 
end
