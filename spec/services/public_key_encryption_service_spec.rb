require "rails_helper"

RSpec.describe PublicKeyEncryptionService, type: :service do
  
  it "should be able to use Public-Key Encryption to encrypt a payload" do
    public_key_encryption = PublicKeyEncryptionService.new
    
    encrypted_payload, nonce = public_key_encryption.encrypt("lorem ipsum")
    
    puts "@DEBUG L:#{__LINE__}   encrypted_payload... '#{encrypted_payload}'"
    puts "@DEBUG L:#{__LINE__}               nonce... '#{nonce            }'"
    
    expect(encrypted_payload.nil?).to eq false
    expect(nonce.nil?).to eq false
  end
    
end