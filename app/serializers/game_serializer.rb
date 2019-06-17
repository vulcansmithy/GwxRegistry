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

  belongs_to :publisher
end
