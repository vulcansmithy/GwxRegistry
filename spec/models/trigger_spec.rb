require 'rails_helper'

RSpec.describe Trigger, type: :model do
  it { should belong_to(:player_profile) }
  it { should belong_to(:action) }
end
