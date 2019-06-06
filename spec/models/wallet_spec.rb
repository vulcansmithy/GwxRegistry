require 'rails_helper'

RSpec.describe Wallet, type: :model do
  it { should belong_to(:account) }
  it { should validate_uniqueness_of (:wallet_address) }
  it { should validate_inclusion_of(:account_type).in_array(Wallet::TYPES) }
end
