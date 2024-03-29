class WalletSerializer
  include FastJsonapi::ObjectSerializer

  attributes :wallet_address, :account_type

  attribute :encrypted_pk do |wallet|
    # re-encrypt the pk
    encrypted_payload_base64, @nonce_base64 = PublicKeyEncryptionService.new.encrypt(wallet.pk)

    encrypted_payload_base64
  end

  attribute :nonce do |wallet|
    @nonce_base64
  end

end
