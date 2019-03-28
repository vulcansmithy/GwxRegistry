require "rails_helper"

RSpec.describe AsymmetricEncryptionService, type: :service do
  
  it "should be able to asymmetrically encrypt a payload" do
    public_key_encryption = AsymmetricEncryptionService.new
    
    encrypted_payload, nonce = public_key_encryption.encrypt("lorem ipsum")
    
    expect(encrypted_payload.nil?).to eq false
    expect(nonce.nil?).to eq false
  end
    
end