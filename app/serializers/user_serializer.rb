class UserSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
    :first_name,
    :last_name,
    :email,
    :wallet_address
end
