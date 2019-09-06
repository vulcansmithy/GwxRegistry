class PlayerProfile < ApplicationRecord
  include Walletable

  after_commit :create_account, on: :create
  belongs_to   :user, optional: true
  belongs_to   :game
  has_one      :wallet, as: :account
  has_many     :triggers

  validates_format_of :username, with: /^[A-Za-z0-9_\.]+$/, multiline: true
end
