require 'rails_helper'

describe Api::V2::TriggersController, fake_nem: true do
  before { mock_nem_service }

  let!(:application)        { create(:application) }
  let!(:token)              { create(:access_token, application: application) }
  let!(:player)             { create(:user, first_name: 'Player') }
  let!(:user)               { create(:user, first_name: 'Publisher') }
  let!(:publisher)          { create(:publisher, user: user) }
  let!(:game)               { create(:game, publisher: publisher) }
  let!(:player_profile)     { create(:player_profile, game: game, user: player) }
  let!(:action)             { create(:action, game: game) }
  let!(:valid_headers)      { generate_headers(player, application) }
  let!(:credential_headers) { generate_auth_headers(token) }
  let(:trigger_params) do
    {
      action_id: action.id,
      player_profile_id: player_profile.id
    }
  end
  describe 'POST /triggers' do
    context 'when params are valid' do
      before { post '/v2/triggers', params: trigger_params.to_json, headers: valid_headers }

      it 'should return status 201' do
        expect(response).to have_http_status :created
      end

      it 'should return correct results' do
        expect(json['data']['attributes']['id']).not_to eq nil
      end
    end

    context 'when params are invalid' do
      before do
        post '/v2/triggers',
             params: {},
             headers: valid_headers
      end
      it 'should return status 422' do
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end
