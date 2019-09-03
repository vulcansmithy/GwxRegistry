class PublicUserSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :first_name,
             :last_name,
             :email

  attribute :wallet_address do |user|
    user.wallet.try(:wallet_address)
  end
end
