class SymmetricEncryptionService
  
  def encrypt(payload)
    
    raise "The passed pk has a empty or nil value." if payload.empty?
    
    secret_key = Base64.urlsafe_decode64(Rails.application.secrets.registry_secret_key)

    secret_box = RbNaCl::SecretBox.new(secret_key)
    
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
  
    encrypted_payload = secret_box.encrypt(nonce, payload)
    
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