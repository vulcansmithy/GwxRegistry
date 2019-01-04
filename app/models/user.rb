class User < ApplicationRecord
  has_one :player, dependent: :destroy
  has_one :publisher, dependent: :destroy
end
