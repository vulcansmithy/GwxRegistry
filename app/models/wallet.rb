class Wallet < ApplicationRecord
  belongs_to :account, polymorphic: true
  
  attr_encrypted :pk, key: Rails.application.secrets.pk_key
  attr_encrypted :custodian_key, key: Rails.application.secrets.custodian_key_secret

  validates_uniqueness_of :wallet_address
end
