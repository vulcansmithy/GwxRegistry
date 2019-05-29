class PlayerProfile < ApplicationRecord
  after_commit :create_account, on: :create
  belongs_to   :user, optional: true
  belongs_to   :game
  has_one      :wallet, as: :account
  has_many     :triggers

  validates_uniqueness_of :username
  validates_presence_of :username
  validates_format_of :username, with: /^[A-Za-z0-9_\.]+$/, multiline: true

  private

  def create_account
    account = NemService.create_account

    self.create_wallet(
      wallet_address: account[:address],
      pk: account[:priv_key]
    )
  end
end
