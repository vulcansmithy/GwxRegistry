class Action < ApplicationRecord
  belongs_to :game, optional: true
  has_many   :triggers, dependent: :destroy
  validates_presence_of :name,
                        :description,
                        :fixed_amount,
                        :unit_fee
end
