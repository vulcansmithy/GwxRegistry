class User < ApplicationRecord
  
  include ActiveModel::SecurePassword

  has_secure_password
  
  attr_encrypted :pk, key: Rails.application.secrets.pk_key
   
  has_one :player,    dependent: :destroy
  has_one :publisher, dependent: :destroy
  
  validates_presence_of   :email,:on => :create   
  validates_uniqueness_of :email
  validates_format_of     :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  
  validates_presence_of   :password, :on => :create
  validates               :password, length: { minimum: 8 }, if: -> (o) { o.blank? }

end
