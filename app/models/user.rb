class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  attr_encrypted :pk, key: Rails.application.secrets.pk_key

  before_create :set_confirmation_code
  after_create :send_confirmation_code

  has_one :player,    dependent: :destroy
  has_one :publisher, dependent: :destroy
  has_one :wallet,    as: :account

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }

  validates :password, presence: true,
                       length: { minimum: 8 },
                       if: :password_digest_changed?

  validates :mac_address, uniqueness: true,
                          allow_nil: true

  validates :confirmation_code, uniqueness: true,
                                allow_nil:  true

  def full_name
    "#{first_name} #{last_name}"
  end

  def confirm_account(code)
    return false unless self.confirmed_at.nil? && code == confirmation_code
    update(confirmation_code: nil, confirmed_at: Time.now.utc)
  end

  def send_confirmation_code
    UserMailer.account_confirmation(self).deliver_later(wait: 1.minute)
  end

  def set_confirmation_code
    self.confirmation_code = SecureRandom.rand.to_s[2..5]
    self.confirmation_sent_at = Time.now.utc
  end
end
