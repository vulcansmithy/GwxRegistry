class User < ApplicationRecord
  mount_uploader :avatar, AvatarUploader
  include ActiveModel::SecurePassword

  has_secure_password

  attr_encrypted :pk, key: Rails.application.secrets.pk_key

  before_create :set_confirmation_code
  after_create :send_confirmation_code

  has_one :publisher, dependent: :destroy
  has_many :player_profiles, dependent: :destroy
  has_many :games, through: :player_profiles
  has_one :wallet, as: :account

  has_many :oauth_applications, class_name: 'Doorkeeper::Application', as: :owner

  has_many :access_grants, class_name: 'Doorkeeper::AccessGrant',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens, class_name: 'Doorkeeper::AccessToken',
                           foreign_key: :resource_owner_id,
                           dependent: :delete_all # or :destroy if you need callbacks

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  validates :password, presence: true,
                       length: { minimum: 8 },
                       if: :password_digest_changed?

  validates :mac_address, uniqueness: true,
                          allow_nil: true

  validates :confirmation_code, uniqueness: true,
                                allow_nil: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def confirm_account(code)
    return false unless code == confirmation_code

    if Time.now.utc > (confirmation_sent_at + 1.hour)
      raise_expired_code
      resend_confirmation!
    end
    confirm!
  end

  def resend_mail
    resend_confirmation! if confirmed_at.nil?
  end

  def send_confirmation_code
    UserMailer.account_confirmation(self).deliver_later(wait: 1.second)
    update(confirmation_sent_at: Time.now.utc)
  end

  def confirm!
    update(confirmation_code: nil, confirmed_at: Time.now.utc)
  end

  def set_confirmation_code
    self.confirmation_code = generate_confirmation_code
  end

  def resend_confirmation!
    update(confirmation_code: generate_confirmation_code)
    send_confirmation_code
  end

  def reset_password!
    update(temporary_password: generate_temporary_password)
    update(password: temporary_password,
           password_confirmation: temporary_password)
    send_temporary_password
  end

  def update_password(params)
    update(temporary_password: nil,
           reset_password_sent_at: nil,
           password: params[:password],
           password_confirmation: params[:password_confirmation])
  end

  def send_temporary_password
    UserMailer.reset_password(self).deliver_later(wait: 1.second)
    update(reset_password_sent_at: Time.now.utc)
  end

  private

  def generate_temporary_password
    SecureRandom.alphanumeric(8)
  end

  def generate_confirmation_code
    loop do
      code = SecureRandom.rand.to_s[2..5]
      break code if User.find_by(confirmation_code: code).nil?
    end
  end

  def raise_expired_code
    raise ExceptionHandler::ExpiredCode, 'Expired confirmation code'
  end
end
