class UserSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :first_name,
             :last_name,
             :email,
             :confirmed_at,
             :confirmation_sent_at,
             :reset_password_sent_at,
             :avatar,
             :username

  attribute :wallet_address do |user|
    user.wallet.try(:wallet_address)
  end

  has_one :publisher
  has_many :player_profiles
  has_many :games
end
