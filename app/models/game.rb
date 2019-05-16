class Game < ApplicationRecord
  after_commit :create_account, on: :create
  belongs_to :publisher
  has_many :player_profiles
  has_one :wallet, as: :account
  has_many :actions, dependent: :destroy

  private

  def create_account
    account = NemService.create_account

    self.create_wallet(
      wallet_address: account[:address],
      pk: account[:priv_key]
    )
  end
end