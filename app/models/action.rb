class Action < ApplicationRecord
  belongs_to :game
  has_many   :triggers
  validates_presence_of :name,
                        :description,
                        :fixed_amount,
                        :unit_fee
end
