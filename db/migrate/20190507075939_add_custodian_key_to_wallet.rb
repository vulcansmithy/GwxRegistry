class AddCustodianKeyToWallet < ActiveRecord::Migration[5.2]
  def change
    add_column :wallets, :encrypted_custodian_key,    :string
    add_column :wallets, :encrypted_custodian_key_iv, :string
    add_index  :wallets, :encrypted_custodian_key_iv, unique: true
  end
end
