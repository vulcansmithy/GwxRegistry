class AddEncFieldsToWallet < ActiveRecord::Migration[5.2]
  def change
    add_column :wallets, :encrypted_pk,    :string
    add_column :wallets, :encrypted_pk_iv, :string
    add_index  :wallets, :encrypted_pk_iv, unique: true
  end
end
