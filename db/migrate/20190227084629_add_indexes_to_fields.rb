class AddIndexesToFields < ActiveRecord::Migration[5.2]
  def change
    add_index :users, [:email, :mac_address, :confirmation_code], unique: true
    add_index :players, :username, unique: true
    add_index :publishers, :publisher_name, unique: true
  end
end
