class PlayerSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
    :username,
    :wallet_address,
    :user_id
end
