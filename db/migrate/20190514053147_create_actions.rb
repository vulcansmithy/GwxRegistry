class CreateActions < ActiveRecord::Migration[5.2]
  def change
    create_table :actions do |t|
      t.string :name
      t.text :description
      t.float :fixed_amount
      t.float :unit_fee
      t.boolean :fixed
      t.boolean :rate
      t.references :game, foreign_key: true

      t.timestamps
    end
  end
end
