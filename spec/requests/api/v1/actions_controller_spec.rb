require "rails_helper"

describe Api::V1::ActionsController do
  let!(:user) { create(:user) }
  let!(:publisher_user) { create(:publisher, user: user) }
  let!(:game) { create(:game, publisher: publisher_user) }
  let!(:actions) { create_list(:action, 3, game: game) }
  let!(:action) { build(:action) }
  let!(:valid_headers) { generate_headers(user) }

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

      it "should return status 404" do
        expect(response.status).to eq 404
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
        get "/v1/games/#{game.id}/actions/#{Action.last.id}",
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

      it "should return status 404" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "PUT /games/:game_id/actions/:id" do
    context "and action params are valid" do
      before do
        put "/v1/games/#{game.id}/actions/#{Action.last.id}",
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
        put "/v1/games/#{game.id}/actions/#{Action.last.id}",
            params: { name: nil }.to_json,
            headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE /games/:game_id/actions/:id" do
    before do
      delete "/v1/games/#{game.id}/actions/#{Action.last.id}",
             params: {},
             headers: valid_headers
    end

    it "should return status 204" do
      expect(response.status).to eq 204
    end

    it "should delete the record" do
      expect(Action.all.count).to eq 2
    end
  end
end
