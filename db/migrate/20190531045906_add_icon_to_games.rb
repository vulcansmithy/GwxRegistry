class AddIconToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :icon, :string
  end
end
