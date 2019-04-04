class AsymmetricEncryptionService
  
  def encrypt(payload)
    # retrieve Registry private key
    decoded_private_key  = Base64.decode64(Rails.application.secrets.registry_private_key)
    registry_private_key = RbNaCl::PrivateKey.new(decoded_private_key)

    # retrieve Cashier public key
    # @TODO need to refactor the hard coded Cashier API url
    response = HTTParty.get("http://localhost:3001/public_key.json")
    
    raise "Can't reach Cashier API" unless response.code == 200
    
    raw_cashier_public_key     = JSON.parse(response.body)["public_key"]
    decoded_cashier_public_key = Base64.decode64(raw_cashier_public_key) 
    cashier_public_key         = RbNaCl::PublicKey.new(decoded_cashier_public_key)
    
    # create a Registry box
    registry_box = RbNaCl::Box.new(cashier_public_key, registry_private_key)

    # generate a nonce
    nonce = RbNaCl::Random.random_bytes(registry_box.nonce_bytes)
    
    # encrypt payload
    encrypted_payload = registry_box.encrypt(nonce, payload)
    
    return Base64.encode64(encrypted_payload), Base64.encode64(nonce)
  end

end