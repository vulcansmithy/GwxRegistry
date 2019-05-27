class GameApplicationSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id, :uid, :secret, :name, :redirect_uri
end