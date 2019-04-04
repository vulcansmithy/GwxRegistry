require "rails_helper"

RSpec.describe Publisher, type: :model do
  it { should validate_uniqueness_of (:publisher_name) }
  it { should validate_presence_of (:publisher_name) }
end
