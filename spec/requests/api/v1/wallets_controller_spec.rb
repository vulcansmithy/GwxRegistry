require "rails_helper"

describe Api::V1::WalletsController, fake_nem: true do
  before { mock_nem_service }

  let(:nem_account) { NemService.create_account }
  let!(:user) { create(:user) }
  let!(:wallet) do
    user.create_wallet(
      wallet_address: nem_account[:address],
      pk: nem_account[:priv_key]
    )
  end
  let(:valid_headers) { generate_headers(user) }

  describe 'GET /:wallet_address' do
    context 'when wallet_address exists' do
      before { get "/wallets/#{wallet.wallet_address}" }

      it 'should return status 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when wallet_address does not exists' do
      before { get "/wallets/ASDASDKASLKDA" }

      it 'should return status 404' do
        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'GET /:wallet_address/balance' do
    before { get "/wallets/#{wallet.wallet_address}" }

    it 'should return 200' do
      expect(response).to have_http_status :ok
    end
  end
end
