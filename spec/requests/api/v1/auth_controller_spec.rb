require 'rails_helper'

describe Api::V1::AuthController, fake_nem: true do
  before { mock_nem_service }
  let!(:application) { create(:application) }
  let!(:token) { create(:access_token, application: application) }
  let!(:nem_account) { NemService.create_account }
  let!(:user) { build(:user) }
  let!(:user2) { create(:user) }
  let(:valid_headers) { generate_headers(user2) }
  let(:credential_headers) { generate_auth_header(token) }
  let!(:wallet) do
    user2.create_wallet(
      wallet_address: nem_account[:address],
      pk: nem_account[:priv_key]
    )
  end
  let(:user_params) do
    {
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      password: user.password,
      password_confirmation: user.password
    }
  end

  describe 'POST /register' do
    context 'when params are valid' do
      before do
        post '/v1/auth/register',
             params: user_params.to_json,
             headers: credential_headers
      end

      it 'should return status 200' do
        expect(response.status).to eq 200
      end

      it 'should login the user' do
        expect(json['token']).not_to eq nil
      end
    end

    context 'when params are invalid' do
      before { post '/v1/auth/register', params: user_params.except(:email), headers: {} }

      it 'should return status 422' do
        expect(response.status).to eq 422
      end
    end
  end

  describe 'POST /register-with-wallet' do
    before do
      post '/v1/auth/register-with-wallet',
           params: user_params,
           headers: {}
    end

    context 'when params are valid' do
      it 'should return status 200' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'POST /login' do
    context 'when credentials are valid' do
      before do
        post '/v1/auth/login',
             params: {
               email: user2.email,
               password: 'password'
             },
             headers: {}
      end

      it 'should return status 200' do
        expect(response.status).to eq 200
      end

      it 'should return JWT token' do
        expect(json['token']).not_to eq nil
      end
    end

    context 'when credentials are invalid' do
      before do
        post '/v1/auth/login',
             params: {
               email: user2.email,
               password: 'password1'
             },
             headers: {}
      end

      it 'should return status 401' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST /console_login' do
    context 'when wallet_address is valid' do
      before do
        post '/v1/auth/console_login',
             params: {
               wallet_address: user2.wallet.wallet_address
             },
             headers: {}
      end

      it 'should return status 200' do
        expect(response.status).to eq 200
      end

      it 'should return JWT token' do
        expect(json['token']).not_to eq nil
      end
    end

    context 'when wallet_address is blank' do
      before do
        post '/v1/auth/console_login',
             params: {
               wallet_address: ""
             }.to_json,
             headers: {}
      end

      it 'should return status 400' do
        expect(response.status).to eq 400
      end
    end

    context 'when wallet_address is invalid' do
      before do
        post '/v1/auth/console_login',
             params: {
              wallet_address: "wallet_address"
             },
             headers: {}
      end

      it 'should return status 401' do
        expect(response.status).to eq 401
      end
    end
  end

  describe 'POST /forgot' do
    context 'when email is found' do
      before do
        post '/v1/auth/forgot',
             params: {
               email: user2.email
             },
             headers: {}
      end
      it 'should return status 200' do
        expect(response.status).to eq 200
      end
      it 'should return message sent' do
        expect(json['message']).to eq 'Sent'
      end
    end

    context 'when email is not found' do
      before do
        post '/v1/auth/forgot',
             params: {
               email: 'noemail@email.com'
             },
             headers: {}
      end
      it 'should return status 400' do
        expect(response.status).to eq 400
      end
    end
  end

  describe 'GET /me' do
    before do
      get '/v1/auth/me', params: {}, headers: valid_headers
    end

    it 'should return status 200' do
      expect(response.status).to eq 200
    end

    it 'should return correct result' do
      expect(json['data']['attributes']['firstName']).to eq user2.first_name
    end

    it 'should include relationship payload' do
      expect(json['data']['relationships'].keys.include?('publisher')).to be_truthy
      expect(json['data']['relationships'].keys.include?('playerProfiles')).to be_truthy
    end
  end

  describe 'POST /confirm/:code' do
    context 'when code is valid' do
      before do
        post "/v1/auth/confirm/#{user2.confirmation_code}",
             params: {},
             headers: {}
      end
      it 'should return status 200' do
        expect(response.status).to eq 200
      end

      it 'should return message Confirmed' do
        expect(json['message']).to eq 'Confirmed'
      end
    end

    context 'when code is invalid' do
      before do
        post "/v1/auth/confirm/0000",
             params: {},
             headers: {}
      end
      it 'should return status 422' do
        expect(response.status).to eq 422
      end
    end
  end

  describe 'GET /resend' do
    before { get '/v1/auth/resend', params: {}, headers: valid_headers }

    it 'should return status 200' do
      expect(response.status).to eq 200
    end
  end

  describe 'PUT /me' do
    context 'when params are valid' do
      before do
        put '/v1/auth/me',
            params: { first_name: 'Noel' }.to_json,
            headers: valid_headers
      end
      it 'should return status 200' do
        expect(response.status).to eq 200
      end
    end
  end

  describe 'PUT /update_password' do
    context 'when params are valid' do
      before do
        put '/v1/auth/update_password',
             params: {
               password: 'newpassword',
               password_confirmation: 'newpassword'
             }.to_json,
             headers: valid_headers
      end

      it 'should return status 200' do
        expect(response.status).to eq 200
      end
    end

    context 'when params are invalid' do
      context 'and password confirmation is missing' do
        before do
          put '/v1/auth/update_password',
               params: {
                 password: 'newpassword'
               }.to_json,
               headers: valid_headers
        end

        it 'should return status 422' do
          expect(response.status).to eq 422
        end
      end

      context 'and passwords doesnt match' do
        before do
          put '/v1/auth/update_password',
               params: {
                 password: 'newpassword',
                 password_confirmation: 'newpass123'
               }.to_json,
               headers: valid_headers
        end

        it 'should return status 422' do
          expect(response.status).to eq 422
        end
      end
    end
  end
end
