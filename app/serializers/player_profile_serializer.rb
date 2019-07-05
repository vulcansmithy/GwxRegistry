class PlayerProfileSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :user_id,
             :game_id,
             :username

  attribute :first_name do |player_profile|
    player_profile.user.first_name
  end

  attribute :last_name do |player_profile|
    player_profile.user.last_name
  end

  attribute :email do |player_profile|
    player_profile.user.email
  end

  attribute :wallet_address do |player_profile|
    player_profile.user.try(:wallet_address)
  end

  attribute :game_wallet_address do |player_profile|
    player_profile.wallet.try(:wallet_address)
  end
end
