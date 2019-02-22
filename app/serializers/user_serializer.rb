class UserSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
    :first_name,
    :last_name,
    :email,
    :wallet_address,
    :confirmed_at,
    :confirmation_sent_at
end
