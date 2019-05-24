class Game < ApplicationRecord
  after_commit :create_account, on: :create
  belongs_to :publisher
  belongs_to :game_application, foreign_key: :oauth_application_id, class_name: 'GameApplication'
  has_many :player_profiles
  has_one :wallet, as: :account
  has_many :actions, dependent: :destroy

  validates_presence_of :name, :description

  private

  def create_account
    account = NemService.create_account

    self.create_wallet(
      wallet_address: account[:address],
      pk: account[:priv_key]
    )
  end
end
