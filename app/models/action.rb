class Action < ApplicationRecord
  belongs_to :game

  validates_presence_of :name,
                        :description,
                        :fixed_amount,
                        :unit_fee
end
