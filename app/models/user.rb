class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  attr_encrypted :pk, key: Rails.application.secrets.pk_key

  has_one :player,    dependent: :destroy
  has_one :publisher, dependent: :destroy

  validates_presence_of   :email, :on => :create
  validates_uniqueness_of :email
  validates_format_of     :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  validates_presence_of   :password, :on => :create
  validates_length_of     :password, minimum: 8
  validates               :mac_address, uniqueness: true unless ENV['RAILS_ENV'] = 'development'
end
