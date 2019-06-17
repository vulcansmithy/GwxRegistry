class Publisher < ApplicationRecord
  include Walletable

  after_commit :create_account, on: :create
  belongs_to :user, optional: true
  has_many :games, dependent: :destroy
  has_one :wallet, as: :account

  validates_uniqueness_of :publisher_name
  validates_presence_of :publisher_name
end
