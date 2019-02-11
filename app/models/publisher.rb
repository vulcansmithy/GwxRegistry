class Publisher < ApplicationRecord
  belongs_to :user, optional: true

  validates_uniqueness_of :publisher_name
  validates_presence_of   :publisher_name, :wallet_address
end
