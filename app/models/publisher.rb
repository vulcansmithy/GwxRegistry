class Publisher < ApplicationRecord
  after_commit :create_account, on: :create
  belongs_to :user, optional: true
  has_many :games
  has_one :wallet, as: :account

  validates_uniqueness_of :publisher_name
  validates_presence_of :publisher_name

  private

  def create_account
    account = NemService.create_account

    self.create_wallet(
      wallet_address: account[:address],
      pk: account[:priv_key]
    )
  end
end
