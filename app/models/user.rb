class User < ApplicationRecord
  include ActiveModel::SecurePassword

  has_secure_password

  attr_encrypted :pk, key: Rails.application.secrets.pk_key

  has_one :player,    dependent: :destroy
  has_one :publisher, dependent: :destroy
  has_one :wallet, as: :account

  validates_presence_of   :email, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_format_of     :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, :on => :create

  validates_presence_of   :password, :on => :create
  validates_length_of     :password, minimum: 8, :on => :create
  validates               :mac_address, uniqueness: true,
                          :on => :create if ENV['RAILS_ENV'] == 'production'

end
