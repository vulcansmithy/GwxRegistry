class AddImagesToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :images, :json
  end
end
