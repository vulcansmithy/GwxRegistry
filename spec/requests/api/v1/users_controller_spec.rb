require "rails_helper"

describe Api::V1::UsersController do

  xit "should implement the endpoint GET /api/v1/users" do
    
    # setup 5 sample Users
    5.times do
      user = create(:user)
    end
    
    # call the API endpoint
    get "/api/v1/users"
    
    # make sure login was successful
    expect(response).to have_http_status(:ok)
  end  
end
