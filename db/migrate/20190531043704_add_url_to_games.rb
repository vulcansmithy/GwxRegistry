class AddUrlToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :url, :string
  end
end
