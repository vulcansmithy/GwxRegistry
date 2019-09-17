class PlayerProfile < ApplicationRecord
  include Walletable

  after_commit :create_account, on: :create

  belongs_to   :user, optional: true
  belongs_to   :game
  has_one      :wallet, as: :account
  has_many     :triggers

  validates :user_id, uniqueness: { scope: :game_id }
end
