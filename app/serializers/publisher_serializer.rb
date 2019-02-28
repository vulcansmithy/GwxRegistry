class PublisherSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
    :publisher_name,
    :wallet_address,
    :user_id
end
