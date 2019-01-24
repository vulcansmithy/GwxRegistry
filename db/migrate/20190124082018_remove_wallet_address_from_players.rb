class RemoveWalletAddressFromPlayers < ActiveRecord::Migration[5.2]
  def change
    remove_column :players, :wallet_address
  end
end
