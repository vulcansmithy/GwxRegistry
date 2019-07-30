require "rails_helper"

describe Api::V2::ServicesController do
  
  it "should be able to return Registry API public_key" do
    
    # call the API endpoint
    get "/public_key"
    
    # make sure the response was :ok
    expect(response).to have_http_status(:ok)
    
    # retrieve result
    result = JSON.parse(response.body)
    
    # decode into raw form
    retrieved_public_key = result["public_key"]

    # make sure the returned public_key matches
    expect(retrieved_public_key).to eq PublicKeyEncryptionService.new.registry_public_key
  end
  
end
