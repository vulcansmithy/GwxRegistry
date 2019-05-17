require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should validate_uniqueness_of (:name) }
  it { should validate_uniqueness_of (:description) }
end
