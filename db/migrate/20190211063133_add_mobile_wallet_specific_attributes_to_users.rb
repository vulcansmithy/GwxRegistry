class AddMobileWalletSpecificAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mac_address, :string
  end
end