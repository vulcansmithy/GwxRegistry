class ChangeColumnName < ActiveRecord::Migration[5.2]
  def change
    rename_column :users, :confirmation_token, :confirmation_code
  end
end
