class WalletSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :wallet_address,
             :encrypted_pk,
             :nonce
  
  attribute :encrypted_pk do |wallet|
    encrypted_payload_base64, @nonce_base64 = SymmetricEncryptionService.new.encrypt(wallet.pk)
  end 
  
  attribute :nonce do |wallet|
    @nonce_base64
  end

end
