class AddGameApplicationIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :game_application_id, :integer, foreign_key: true
    add_index :games, :game_application_id
  end
end
