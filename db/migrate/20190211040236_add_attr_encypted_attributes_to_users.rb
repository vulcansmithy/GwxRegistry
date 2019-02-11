class AddAttrEncyptedAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :encrypted_pk,    :string
    add_column :users, :encrypted_pk_iv, :string
    add_index  :users, :encrypted_pk_iv, unique: true
  end
end