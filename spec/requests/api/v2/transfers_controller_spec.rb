require 'rails_helper'

describe Api::V2::TransfersController, fake_name: true do
  before { mock_nem_service }

  let!(:application)        { create(:application) }
  let!(:token)              { create(:access_token, application: application) }
  let!(:credential_headers) { generate_auth_headers(token) }
  let(:nem_account)         { NemService.create_account }
  let!(:user)               { create(:user) }
  let!(:wallet) do
    user.create_wallet(
      wallet_address: nem_account[:address],
      pk: nem_account[:priv_key]
    )
  end
  let!(:player) { create(:player_profile, user: user) }

  describe 'GET /transfers/balance/:username' do
    context 'when username exists' do
      before do
        get "/v2/transfers/balance/#{player.username}",
            params: {},
            headers: credential_headers
      end

      it 'should return status 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when username does not exists' do
      before do
        get '/v2/transfers/balance/one',
            params: {},
            headers: credential_headers
      end

      it 'should return status 404' do
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
