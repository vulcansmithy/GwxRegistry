class AddTransactionIdToTriggers < ActiveRecord::Migration[5.2]
  def change
    add_column :triggers, :transaction_id, :integer
  end
end
