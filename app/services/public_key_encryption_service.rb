# Asymmetric Encryption
class PublicKeyEncryptionService
  
  class EncryptionFailedError < StandardError; end
  
  def registry_public_key
    
    raise EncryptionFailedError, "Passed 'registry_private_key' was either nil or empty." if nil_or_empty?(ENV['REGISTRY_PRIVATE_KEY'])

    # retrieve Registry private key
    registry_private_key = RbNaCl::PrivateKey.new(decode_from_base64(ENV['REGISTRY_PRIVATE_KEY']))
    return encode_to_base64(registry_private_key.public_key)
  end  
  
  def encrypt(payload)
    
    raise EncryptionFailedError, "Passed 'registry_private_key' was either nil or empty." if nil_or_empty?(ENV['REGISTRY_PRIVATE_KEY'])

    raise EncryptionFailedError, "Passed 'cashier_public_key' was either nil or empty." if nil_or_empty?(ENV['CASHIER_PUBLIC_KEY'])

    begin
      # retrieve Registry private key
      registry_private_key = RbNaCl::PublicKey.new(decode_from_base64(ENV['REGISTRY_PRIVATE_KEY']))

      # retrieve Cashier public key
      cashier_public_key = RbNaCl::PublicKey.new(decode_from_base64(ENV['CASHIER_PUBLIC_KEY']))

    
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
      
    rescue RbNaCl::LengthError => e
      raise EncryptionFailedError, e.message 
    rescue Exception => e  
      raise EncryptionFailedError, e.message
    end   

  end
  
  private
  def decode_from_base64(value)
    Base64.urlsafe_decode64(value)
  end
  
  def encode_to_base64(value)
    Base64.urlsafe_encode64(value)
  end
  
  def nil_or_empty?(value)
    return value.nil? || value.empty?  
  end

end