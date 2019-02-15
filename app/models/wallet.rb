class Wallet < ApplicationRecord
  belongs_to :account, polymorphic: true
end
