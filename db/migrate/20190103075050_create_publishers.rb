class CreatePublishers < ActiveRecord::Migration[5.2]
  def change
    create_table :publishers do |t|
      t.string :wallet_address
      t.string :description
      t.decimal :balance

      t.timestamps
    end
  end
end
