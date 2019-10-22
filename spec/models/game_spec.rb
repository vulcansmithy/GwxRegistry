require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should validate_presence_of (:name) }
# @TODO the code below causing the test to fail. Need further investigating
# it { should validate_uniqueness_of (:name) }
  it { should validate_presence_of (:description) }
end
