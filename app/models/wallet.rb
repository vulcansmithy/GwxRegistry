class Wallet < ApplicationRecord
  belongs_to :account, polymorphic: true

  attr_encrypted :pk, key: ENV['PK_KEY']
  attr_encrypted :custodian_key, key: ENV['CUSTODIAN_KEY_SECRET']

  TYPES = %w[Game User PlayerProfile Publisher].freeze

  validates_uniqueness_of :wallet_address
  validates :account_type, inclusion: { in: TYPES }

  def type
    account_type
  end

  def type_of?(account)
    account == self.type
  end
end
