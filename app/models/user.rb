class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  attr_encrypted :pk, key: Rails.application.secrets.pk_key

  has_one :player,    dependent: :destroy
  has_one :publisher, dependent: :destroy
  has_one :wallet,    as: :account

  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  validates :password, presence: true, length: { minimum: 8 },
                       if: :password_digest_changed?

  validates :mac_address, uniqueness: true, allow_nil: true

  validates :confirmation_code, uniqueness: true, allow_nil: true

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

  def resend_confirmation!
    update(confirmation_code: generate_confirmation_code)
    send_confirmation_code
  end

  private

  def generate_confirmation_code
    loop do
      code = SecureRandom.rand.to_s[2..5]
      break code if User.find_by(confirmation_code: code).nil?
    end
  end

  def raise_expired_code
    raise ExceptionHandler::ExpiredCode, "Expired confirmation code"
  end
end
