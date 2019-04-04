class Wallet < ApplicationRecord
  belongs_to :account, polymorphic: true
  attr_encrypted :pk, key: Rails.application.secrets.pk_key

  validates_uniqueness_of :wallet_address
end
