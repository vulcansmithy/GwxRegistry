class AddPlatformToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :platforms, :text, array: true, default: []
  end
end
