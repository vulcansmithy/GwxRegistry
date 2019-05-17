class Wallet < ApplicationRecord
  belongs_to :account, polymorphic: true

  attr_encrypted :pk, key: Rails.application.secrets.pk_key
  attr_encrypted :custodian_key, key: Rails.application.secrets.custodian_key_secret

  TYPES = %w[Game User PlayerProfile Publisher].freeze

  validates_uniqueness_of :wallet_address
  validates :account_type, inclusion: { in: TYPE }

  def type
    account_type
  end

  def type_of?(account)
    account == self.type
  end
end
