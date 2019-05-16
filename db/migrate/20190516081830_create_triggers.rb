class CreateTriggers < ActiveRecord::Migration[5.2]
  def change
    create_table :triggers do |t|
      t.references :player_profile, foreign_key: true
      t.references :action, foreign_key: true
      t.timestamps
    end
  end
end
