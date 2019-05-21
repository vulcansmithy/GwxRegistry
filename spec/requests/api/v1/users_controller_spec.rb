require "rails_helper"

describe Api::V1::UsersController do
  let!(:users) { create_list(:user, 5) }

  describe 'GET /users' do
    before { get '/v1/users' }

    it 'should return status 200' do
      expect(response).to have_http_status :ok
    end

    it 'should return correct results' do
      expect(json['data'].count).to eq 5
    end
  end

  describe 'GET /users/:id' do
    context 'when user exists' do
      before { get "/v1/users/#{users.first.id}" }

      it 'should return status 200' do
        expect(response).to have_http_status :ok
      end
    end

    context 'when user does not exists' do
      before { get '/v1/users/-1' }

      it 'should return status 404' do
        expect(response).to have_http_status :not_found
      end
    end
  end
end
