class Trigger < ApplicationRecord
  belongs_to :player_profile
  belongs_to :action, optional: true
end
