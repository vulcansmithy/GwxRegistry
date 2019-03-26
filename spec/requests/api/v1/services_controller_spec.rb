require "rails_helper"

describe Api::V1::ServicesController do
  
  it "should be able to return Registry API public_key" do
    
    # call the API endpoint
    get "/public_key"
    
    # retrieve result
    result = JSON.parse(response.body)
    
    # decode into raw form
    retrieved_pk = Base64.decode64(result["public_key"])
    saved_pk     = Base64.decode64(Rails.application.secrets.registry_public_key)

    # make sure the returned public_key matches
    expect(retrieved_pk).to eq saved_pk
  end
  
end
