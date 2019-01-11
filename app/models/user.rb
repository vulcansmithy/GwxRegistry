class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  has_one :player, dependent: :destroy
  has_one :publisher, dependent: :destroy
end
