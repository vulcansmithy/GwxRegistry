class SymmetricEncryptionService
  
  def encrypt(payload)
Rails.logger.debug("Rails.application.secrets.registry_secret_key: '#{Rails.application.secrets.registry_secret_key}'")
    secret_key = Base64.urlsafe_decode64(Rails.application.secrets.registry_secret_key)
Rails.logger.debug("L:6   MARKED")  

    secret_box = RbNaCl::SecretBox.new(secret_key)
Rails.logger.debug("L:9   secret_box.nil?: #{secret_box.nil?}") 
    
r = secret_box.nonce_bytes
Rails.logger.debug "secret_box.nonce_bytes: '#{secret_box.nonce_bytes}'"    
    nonce = RbNaCl::Random.random_bytes(r)
Rails.logger.debug("L:14   nonce='#{nonce}'")     
  
Rails.logger.debug "L:16  payload='#{payload}'"   
    encrypted_payload = secret_box.encrypt(nonce, payload)
Rails.logger.debug("L:18   MARKED") 
    
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