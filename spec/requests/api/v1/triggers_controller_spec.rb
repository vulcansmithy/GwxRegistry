require 'rails_helper'

describe Api::V1::TriggersController do
  let!(:player) { create(:user, first_name: 'Player') }
  let!(:user) { create(:user, first_name: 'Publisher') }
  let!(:publisher) { create(:publisher, user: user) }
  let!(:game) { create(:game, publisher: publisher) }
  let!(:action) { create(:action, game: game) }

  describe 'POST /triggers' do
    context 'when params are valid' do
      it 'should return status 201' do
      end
    end

    context 'when params are invalid' do
      it 'should return status 422' do
      end
    end
  end
end
