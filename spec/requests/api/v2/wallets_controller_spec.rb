require "rails_helper"

describe Api::V2::WalletsController, fake_nem: true do
  before { mock_nem_service }

  let!(:application)        { create(:application) }
  let!(:token)              { create(:access_token, application: application) }
  let(:nem_account)         { NemService.create_account }
  let!(:credential_headers) { generate_auth_headers(token) }
  let!(:user)               { create(:user) }
  let!(:wallet) do
    user.create_wallet(
      wallet_address: nem_account[:address],
      pk: nem_account[:priv_key]
    )
  end
  let(:valid_headers) { generate_headers(user) }

  describe 'GET /v2/:wallet_address' do
    context 'when wallet_address exists' do
      before { get "/v2/wallets/#{wallet.wallet_address}", params: {}, headers: credential_headers }

      it 'should return status 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when wallet_address does not exists' do
      before { get '/v2/wallets/ASDASDKASLKDA', params: {}, headers: credential_headers }

      it 'should return status 404' do
        expect(response).to have_http_status :not_found
      end
    end

    context 'when querying with account_id and account_type' do
      before { get "/v2/wallets/#{user.id}?account_type=user", params: {}, headers: credential_headers }

      it 'should return status 200' do
        expect(response).to have_http_status :ok
      end

      it 'should return correct result' do
        expect(json['data']['attributes']['wallet_address']).to eq nem_account[:address]
      end
    end
  end

  describe 'GET /:wallet_address/balance' do
    before { get "/v2/wallets/#{wallet.wallet_address}", params: {}, headers: credential_headers }

    it 'should return 200' do
      expect(response).to have_http_status :ok
    end
  end
end
