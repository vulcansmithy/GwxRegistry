class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  has_one :player, dependent: :destroy
  has_one :publisher, dependent: :destroy

  validates_presence_of   :email, 
  validate_presence_of    :password
  validates_uniqueness_of :email
  validates_format_of     :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates_length_of     :password, minimum: 8
end
