class AddGameReferenceToPlayerProfiles < ActiveRecord::Migration[5.2]
  def change
    add_reference :player_profiles, :game, foreign_key: true
  end
end
