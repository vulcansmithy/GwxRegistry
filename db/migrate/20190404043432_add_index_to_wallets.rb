class AddIndexToWallets < ActiveRecord::Migration[5.2]
  def change
    add_index :wallets, :wallet_address, unique: true
  end
end
