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
  validate :validate_platforms

  PLATFORMS = %w(console windows macos android ios).freeze

  private

  def create_account
    account = NemService.create_account

    self.create_wallet(
      wallet_address: account[:address],
      pk: account[:priv_key]
    )
  end

  def validate_platforms
    game_platform = platforms.map { |p| PLATFORMS.include?(p.downcase) }
    unless game_platform.include?(false) == false
      errors[:base] << "Unknown Platform"
      return true
    end
  end
end
