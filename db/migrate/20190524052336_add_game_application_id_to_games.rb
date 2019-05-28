class AddGameApplicationIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_reference :games, :oauth_application, foreign_key: true
  end
end
