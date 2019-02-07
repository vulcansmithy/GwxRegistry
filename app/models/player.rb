class Player < ApplicationRecord

  belongs_to :user, optional: true

  validates_uniqueness_of :username
  validates_presence_of   :username
  
end
