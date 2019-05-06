require "rails_helper"

RSpec.describe PublicKeyEncryptionService, type: :service do
  
  it "should be able to use Public-Key Encryption to encrypt a payload" do
    public_key_encryption = PublicKeyEncryptionService.new
    
    # setup the plaintext payload
    plaintext_payload = "lorem ipsum"
    
    # encrypt the plaintext payload
    encrypted_payload, nonce = public_key_encryption.encrypt(plaintext_payload)
    
    # make sure the encrypted payload is correctly decrypted
    expect(decrypt(encrypted_payload, nonce)).to eq plaintext_payload
  end
  
  it "should be able to retrive the Public Key assigned to Registry" do

    # make sure the retrieved Registry Public Key matches  
    expect(PublicKeyEncryptionService.new.registry_public_key).to eq "jhSTM7K2hzdSg0M1nYkNLPI_4JSI188qDgwu7C0cHS8="
  end
  
  def decrypt(encrypted_payload, nonce)
    
    # decode the base64 public key of Registry
    registry_public_key = RbNaCl::PublicKey.new(Base64.urlsafe_decode64(PublicKeyEncryptionService.new.registry_public_key))
    
    # decode the base64 private key of Cashier
    cashier_private_key = RbNaCl::PublicKey.new(Base64.urlsafe_decode64("LSHtsZqVQiygbf97PyYjedu_ts5i9vJabw0R6saRP9Y="))
    
    # setup a Test Box
    test_box = RbNaCl::Box.new(registry_public_key, cashier_private_key)

    # decrypt the encrypted payload
    decrypted_payload = test_box.decrypt(Base64.urlsafe_decode64(nonce), Base64.urlsafe_decode64(encrypted_payload))


    return decrypted_payload
  end  
end