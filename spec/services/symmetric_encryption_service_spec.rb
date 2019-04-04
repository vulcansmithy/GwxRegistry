require "rails_helper"

RSpec.describe SymmetricEncryptionService, type: :service do
  
  it "should be able to perform a symmetrically encrypt" do
    
    symmetric_encryption = SymmetricEncryptionService.new
    
    # setup test payload
    test_payload = "Lorem ipsum"
    
    # use symmetric encryption to encrypt the test_payload
    encrypted_payload_base64, nonce_base64 = symmetric_encryption.encrypt(test_payload)
    
    # use symmetric encryption to decrypt the encrypted test_payload  
    decrypted_payload = symmetric_encryption.decrypt(encrypted_payload_base64, nonce_base64)    
    
    puts "@DEBUG L:#{__LINE__}   decrypted_payload... '#{decrypted_payload}'"
    
    # make sure the test_payload matches with the decrypted_payload
    expect(decrypted_payload).to eq test_payload
  end
    
end