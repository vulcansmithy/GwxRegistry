class AddUserToPublisher < ActiveRecord::Migration[5.2]
  def change
    add_reference :publishers, :user, foreign_key: true
  end
end
