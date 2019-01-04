class CreatePlayers < ActiveRecord::Migration[5.2]
  def change
    create_table :players do |t|
      t.string :wallet_address
      t.string :username
      t.decimal :balance

      t.timestamps
    end
  end
end
