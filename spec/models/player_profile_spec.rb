require "rails_helper"

RSpec.describe PlayerProfile, type: :model do
  it { should validate_uniqueness_of (:username) }
  it { should validate_presence_of (:username) }
end
