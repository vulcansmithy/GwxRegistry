class PublisherSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :publisher_name,
             :wallet_address,
             :description,
             :user_id

  attribute :wallet_address do |publisher|
    publisher.user.wallet_address
  end

  attribute :game_wallet_address do |publisher|
    publisher.wallet.wallet_address
  end
end
