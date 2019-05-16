class TriggerSerializer < ActiveModel::Serializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :action_id,
             :player_profile_id,
             :created_at

  belongs_to :action
  belongs_to :player_profile
end
