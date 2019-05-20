class ActionSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :name,
             :description,
             :fixed_amount,
             :unit_fee,
             :fixed,
             :rate

  belongs_to :game
end
