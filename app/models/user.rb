class User < ApplicationRecord
  include ActiveModel::SecurePassword, Confirmable, Recoverable

  mount_uploader :avatar, AvatarUploader

  has_secure_password

  attr_encrypted :pk, key: Rails.application.secrets.pk_key

  before_create :set_confirmation_code
  after_create :send_confirmation_code

  has_one :publisher, dependent: :destroy
  has_many :player_profiles, dependent: :destroy
  has_many :games, through: :player_profiles, dependent: :nullify
  has_one :wallet, as: :account

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  validates :first_name, :last_name, presence: true

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  validates_format_of :username, with: /^[A-Za-z0-9_\.]+$/, multiline: true, allow_nil: true

  validates :password, :password_confirmation, presence: true,
                                               length: { minimum: 8 },
                                               if: :password_digest_changed?

  validates :confirmation_code, uniqueness: true,
                                allow_nil: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def publisher?
    publisher.present?
  end
end
