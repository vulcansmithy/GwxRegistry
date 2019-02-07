class AddPublisherNameToPublishers < ActiveRecord::Migration[5.2]
  def change
    add_column :publishers, :publisher_name, :string
  end
end
