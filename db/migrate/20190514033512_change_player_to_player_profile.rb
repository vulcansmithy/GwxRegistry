class ChangePlayerToPlayerProfile < ActiveRecord::Migration[5.2]
  def change
    rename_table :players, :player_profiles
  end
end
