class AuthGameSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :name,
             :description

  belongs_to :publisher
  belongs_to :game_application
end
