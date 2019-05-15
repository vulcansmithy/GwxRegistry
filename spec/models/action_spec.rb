require 'rails_helper'

RSpec.describe Action, type: :model do
  describe "validations" do
    it { should validate_presence_of (:name) }
    it { should validate_presence_of (:description) }
    it { should validate_presence_of (:fixed_amount) }
    it { should validate_presence_of (:unit_fee) }
  end
end
