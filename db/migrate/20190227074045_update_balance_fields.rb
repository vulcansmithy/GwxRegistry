class UpdateBalanceFields < ActiveRecord::Migration[5.2]
  def change
    change_column :players, :balance, :decimal, precision: 8, scale: 6
    change_column :publishers, :balance, :decimal, precision: 8, scale: 6
  end
end
