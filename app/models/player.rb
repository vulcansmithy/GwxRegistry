class Player < ApplicationRecord
  belongs_to :user, optional: true
  has_one :wallet,  as: :account

  validates_uniqueness_of :username
  validates_presence_of   :username
  validates_format_of     :username, :with => /^[A-Za-z0-9_\.]+$/, multiline: true
end
