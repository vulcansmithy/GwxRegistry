class PublisherSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :publisher_name,
             :description,
             :user_id

  attribute :wallet_address do |publisher|
    publisher.user.try(:wallet_address)
  end

  attribute :game_wallet_address do |publisher|
    publisher.wallet.try(:wallet_address)
  end
end
