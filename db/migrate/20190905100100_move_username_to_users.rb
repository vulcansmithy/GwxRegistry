class MoveUsernameToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :username, :string
    remove_column :player_profiles, :username
  end
end
