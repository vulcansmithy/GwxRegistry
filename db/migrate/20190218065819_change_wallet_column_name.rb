class ChangeWalletColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :wallets, :address, :wallet_address
    rename_column :wallets, :type, :wallet_type
  end
end
