class Trigger < ApplicationRecord
  belongs_to :player_profile, optional: true
  belongs_to :action, optional: true
end
