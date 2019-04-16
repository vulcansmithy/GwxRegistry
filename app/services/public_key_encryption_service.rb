# Asymmetric Encryption
class PublicKeyEncryptionService
  
  def registry_public_key

    # retrieve Registry private key
    registry_private_key = RbNaCl::PrivateKey.new(decode_from_base64(Rails.application.secrets.registry_private_key))
    
    return encode_to_base64(registry_private_key.public_key)
  end  
  
  def encrypt(payload)

    # retrieve Registry private key
    registry_private_key = RbNaCl::PublicKey.new(decode_from_base64(Rails.application.secrets.registry_private_key))

    # retrieve Cashier public key
    cashier_public_key = RbNaCl::PublicKey.new(decode_from_base64(Rails.application.secrets.cashier_public_key))
    
    # setup Register's box
    register_box = RbNaCl::Box.new(cashier_public_key, registry_private_key)
    
    # generate a nonce
    nonce = RbNaCl::Random.random_bytes(register_box.nonce_bytes)
    
    ##
    ## encrypt the Payload
    encrypted_payload = register_box.encrypt(nonce, payload)
    ##
    ##
    
    # URL encode the nonce
    base64_nonce = encode_to_base64(nonce)
    
    # URL encode the encrypted_payload
    base64_encrypted_payload = encode_to_base64(encrypted_payload)
 
    
    return base64_encrypted_payload, base64_nonce
  end
  
  private
  def decode_from_base64(value)
    Base64.urlsafe_decode64(value)
  end
  
  def encode_to_base64(value)
    Base64.urlsafe_encode64(value)
  end

end