class PublisherSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
    :publisher_name,
    :wallet_address,
    :description,
    :user_id
end
