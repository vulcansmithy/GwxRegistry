require 'rails_helper'

describe Api::V2::TransfersController, fake_nem: true do
  before { mock_nem_service }
  let(:nem_account) { NemService.create_account }
  let!(:user) { create(:user) }
  let!(:wallet) do
    user.create_wallet(
      wallet_address: nem_account[:address],
      pk: nem_account[:priv_key]
    )
  end
  let!(:player) { create(:player_profile, user: user) }

  describe 'GET /transfers/balance/:username' do
    context 'when username exists' do
      before { get "/transfers/balance/#{player.username}" }

      it 'should return status 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when username does not exists' do
      before { get '/transfers/balance/one' }

      it 'should return status 404' do
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
