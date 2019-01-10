class Publisher < ApplicationRecord
  belongs_to :user, optional: true
end
