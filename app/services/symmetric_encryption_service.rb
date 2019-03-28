class SymmetricEncryptionService
  
  def encrypt(payload)
    secret_key = Base64.urlsafe_decode64(Rails.application.secrets.registry_secret_key)
  
    secret_box = RbNaCl::SecretBox.new(secret_key)
    
    nonce = RbNaCl::Random.random_bytes(secret_box.nonce_bytes)
    
    encrypted_payload = secret_box.encrypt(nonce, payload)
    
    return Base64.urlsafe_decode64(encrypted_payload), Base64.urlsafe_decode64(nonce) 
  end
  
end