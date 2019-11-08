require "rails_helper"

include WalletPkSecurity::Splitter

describe Api::V1::WalletsController, fake_nem: true do
  before { mock_nem_service }

  let(:nem_account) { NemService.create_account }
  let!(:user) { create(:user) }
  let!(:wallet) do
    result = split_up_and_distribute(nem_account[:address], nem_account[:priv_key])
    user.create_wallet(
      wallet_address: nem_account[:address],
      pk: nem_account[:priv_key],
      custodian_key: result[:shards][0]
    )
  end
  let(:valid_headers) { generate_jwt_headers(user) }

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
    
    context 'when querying with account_id and account_type' do
      before { get "/wallets/#{user.id}?account_type=user" }

      it 'should return status 200' do
        expect(response).to have_http_status :ok
      end

      it 'should return correct result' do
        expect(json['data']['attributes']['wallet_address']).to eq nem_account[:address]
      end
    end
  end

  describe 'GET /:wallet_address/balance' do
    before { get "/wallets/#{wallet.wallet_address}" }

    it 'should return 200' do
      expect(response).to have_http_status :ok
    end
  end
  
  def distribute_shards(wallet_address, shards)
    # Do not remove this. This method is essential for 
    # successfully running all the test in this rspec test.
  end
    
end
