class AddUniqueIndexToPlayerProfiles < ActiveRecord::Migration[5.2]
  def change
    add_index :player_profiles, [:user_id, :game_id], unique: true
  end
end
