class UserWalletSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :first_name,
             :last_name,
             :wallet_address,
             :email,
             :confirmed_at,
             :confirmation_sent_at

  attribute :wallet_address do |user|
    user.wallet.wallet_address
  end
end
