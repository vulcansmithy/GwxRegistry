class GameSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :name,
             :description,
             :platforms,
             :icon,
             :images,
             :cover,
             :url

  attribute :game_wallet_address do |game|
    game.wallet.try(:wallet_address)
  end

  belongs_to :publisher
  has_many :player_profiles
end
