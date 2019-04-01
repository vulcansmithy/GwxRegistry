class SymmetricEncryptionService
  
  def encrypt(payload)
debug.log("Rails.application.secrets.registry_secret_key: '#{Rails.application.secrets.registry_secret_key}'")
    secret_key = Base64.urlsafe_decode64(Rails.application.secrets.registry_secret_key)
debug.log("{__LINE__}   MARKED")  

    secret_box = RbNaCl::SecretBox.new(secret_key)
debug.log("{__LINE__}   secret_box.nil?: #{secret_box.nil?}") 
    
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
debug.log("{__LINE__}   nonce='#{nonce}'")     
    
    encrypted_payload = secret_box.encrypt(nonce, payload)
debug.log("{__LINE__}   MARKED") 
    
    return Base64.urlsafe_encode64(encrypted_payload), Base64.urlsafe_encode64(nonce) 
  end
  
  def decrypt(encrypted_payload_base64, nonce_base64)
    secret_key        = Base64.urlsafe_decode64(Rails.application.secrets.registry_secret_key) 
    nonce             = Base64.urlsafe_decode64(nonce_base64)
    encrypted_payload = Base64.urlsafe_decode64(encrypted_payload_base64)
    
    secret_box = RbNaCl::SecretBox.new(secret_key)
    
    return secret_box.decrypt(nonce, encrypted_payload)
  end  
  
end