class PlayerSerializer < ActiveModel::Serializer
  
  include FastJsonapi::ObjectSerializer

  attributes :user_id,
    :first_name,
    :last_name,
    :email,
    :username,
    :wallet_address

  attribute :first_name do |player|
    player.user.first_name
  end     
  
  attribute :last_name do |player|
    player.user.last_name
  end  
  
  attribute :email do |player|
    player.user.email
  end        

end
