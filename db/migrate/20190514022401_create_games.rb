class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :name
      t.string :description
      t.references :publisher, foreign_key: true

      t.timestamps
    end
  end
end
