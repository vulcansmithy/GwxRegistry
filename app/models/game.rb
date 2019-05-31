class Game < ApplicationRecord
  mount_uploader  :icon,   AvatarUploader
  mount_uploaders :images, ImageUploader

  after_commit :create_account, on: :create
  belongs_to :publisher
  belongs_to :game_application, optional: true
  has_many :player_profiles
  has_one :wallet, as: :account
  has_many :actions, dependent: :destroy
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :tags

  validates_presence_of :name, :description
  validates :game_platforms

  PLATFORMS = %w(Console Windows MacOs Android Ios).freeze

  private

  def create_account
    account = NemService.create_account

    self.create_wallet(
      wallet_address: account[:address],
      pk: account[:priv_key]
    )
  end
end
