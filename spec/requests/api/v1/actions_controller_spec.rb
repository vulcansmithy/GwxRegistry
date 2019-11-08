require "rails_helper"

describe Api::V1::ActionsController, fake_nem: true do
  before { mock_nem_service }

  let!(:user) { create(:user) }
  let!(:player_user) { create(:user) }
  let!(:publisher_user) { create(:publisher, user: user) }
  let!(:game) { create(:game, publisher: publisher_user) }
  let!(:player_profile) { create(:player_profile, user: player_user, game: game) }
  let!(:actions) { create_list(:action, 3, game: game) }
  let!(:action) { build(:action) }
  let!(:triggers) do
    create_list :trigger, 5, action: Action.first,
                             player_profile: player_profile
  end
  let!(:valid_headers) { generate_jwt_headers(user) }

  let(:action_params) do
    {
      name: action.name,
      description: action.description,
      fixed_amount: action.fixed_amount,
      unit_fee: action.unit_fee,
      fixed: action.fixed,
      rate: action.rate
    }
  end

  describe "GET /games/:game_id/actions" do
    context "when game exists" do
      before do
        get "/v1/games/#{game.id}/actions",
            params: {},
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should return correct results" do
        expect(json['data'].count).to eq 3
      end
    end

    context "when game doesn't exist" do
      before do
        get "/v1/games/-1/actions",
            params: {},
            headers: valid_headers
      end

      it "should return status 400" do
        expect(response.status).to eq 400
      end
    end
  end

  describe "POST /games/:game_id/actions" do
    context "when action params are valid" do
      before do
        post "/v1/games/#{game.id}/actions",
             params: action_params.to_json,
             headers: valid_headers
      end

      it "should return status 201" do
        expect(response.status).to eq 201
      end

      it "should return correct result" do
        expect(json['data']['attributes']['name']).to eq action.name
      end
    end

    context "when action params are invalid" do
      before do
        post "/v1/games/#{game.id}/actions",
             params: action_params.except(:name).to_json,
             headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "GET /games/:game_id/actions/:id" do
    context "when action exists" do
      before do
        get "/v1/games/#{game.id}/actions/#{Action.first.id}",
            params: {},
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end
    end

    context "when action doesn't exists" do
      before do
        get "/v1/games/#{game.id}/actions/-1",
            params: {},
            headers: valid_headers
      end

      it "should return status 400" do
        expect(response.status).to eq 400
      end
    end
  end

  describe "PUT /games/:game_id/actions/:id" do
    context "and action params are valid" do
      before do
        put "/v1/games/#{game.id}/actions/#{Action.first.id}",
            params: { name: "New name" }.to_json,
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should update the record" do
        expect(json['data']['attributes']['name']).to eq "New name"
      end
    end

    context "and action params are invalid" do
      before do
        put "/v1/games/#{game.id}/actions/#{Action.first.id}",
            params: { name: nil }.to_json,
            headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe 'GET /actions/:id/triggers' do
    context 'when action is found' do
      before do
        get "/v1/actions/#{Action.first.id}/triggers",
            params: {},
            headers: valid_headers
      end

      it 'should return status 200' do
        expect(response.status).to eq 200
      end

      it 'should return correct triggers result' do
        expect(json['data'].count).to eq 5
      end
    end

    context 'when action is not found' do
      before do
        get '/v1/actions/-1/triggers', params: {}, headers: valid_headers
      end
      it 'should return status 400' do
        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe "DELETE /games/:game_id/actions/:id" do
    before do
      delete "/v1/games/#{game.id}/actions/#{Action.last.id}",
             params: {},
             headers: valid_headers
    end

    it "should return status 200" do
      expect(response.status).to eq 200
    end

    it "should delete the record" do
      expect(Action.all.count).to eq 2
    end
  end

end
