class AddPasswordToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :temporary_password, :string
  end
end
