class CreateWallets < ActiveRecord::Migration[5.2]
  def change
    create_table :wallets do |t|
      t.string :address
      t.references :account, polymorphic: true, index: true
      t.timestamps
    end
  end
end
