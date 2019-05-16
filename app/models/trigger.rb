class Trigger < ApplicationRecord
  belongs_to :player_profile
  belongs_to :game
end
