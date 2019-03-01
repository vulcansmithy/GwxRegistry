class PublisherSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  attributes :id,
    :publisher_name,
    :description,
    :wallet_address,
    :user_id
end
