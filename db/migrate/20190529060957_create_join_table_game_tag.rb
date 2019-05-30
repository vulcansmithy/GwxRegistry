class CreateJoinTableGameTag < ActiveRecord::Migration[5.2]
  def change
    create_join_table :games, :tags do |t|
      t.index [:game_id, :tag_id], unique: true
    end
  end
end
