class AddBlocklistCountryInGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :blacklisted_countries, :string, array: true, default: []
  end
end
