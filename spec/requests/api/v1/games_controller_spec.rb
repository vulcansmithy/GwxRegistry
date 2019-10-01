require "rails_helper"

describe Api::V1::GamesController, fake_nem: true do
  before { mock_nem_service }

  let!(:user) { create(:user) }
  let!(:publisher_user) { create(:publisher, user: user) }
  let!(:game) { create(:game, publisher: publisher_user) }
  let!(:new_game) { build(:game, publisher: publisher_user) }
  let!(:games) { create_list(:game, 2, publisher: publisher_user) }
  let!(:valid_headers) { generate_jwt_headers(user) }

  let!(:game_params) do
    {
      name: new_game.name,
      description: new_game.description
    }
  end

  describe "GET /games/" do
    before do
      get "/v1/games/",
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

  describe "POST /games/" do
    context "when game params are valid" do
      before do
        post "/v1/games",
             params: game_params.to_json,
             headers: valid_headers
      end

      it "should return status 201" do
        expect(response.status).to eq 201
      end

      it "should return correct result" do
        expect(json['data']['attributes']['name']).to eq new_game.name
      end
    end

    context "when game params are invalid" do
      before do
        post "/v1/games",
             params: game_params.except(:name).to_json,
             headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "GET /games/:id" do
    context "when game exists" do
      before do
        get "/v1/games/#{Game.last.id}",
            params: {},
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end
    end

    context "when action doesn't exists" do
      before do
        get "/v1/games/-1",
            params: {},
            headers: valid_headers
      end

      it "should return status 400" do
        expect(response.status).to eq 400
      end
    end
  end

  describe "PUT /games/:id" do
    context "when game params are valid" do
      before do
        put "/v1/games/#{Game.last.id}",
            params: { name: "New name" }.to_json,
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should update the record" do
        expect(json['data']['attributes']['name']). to eq "New name"
      end
    end

    context "when game params are invalid" do
      before do
        put "/v1/games/#{Game.last.id}",
          params: { name: nil }.to_json,
          headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE /games/:id" do
    before do
      delete "/v1/games/#{Game.last.id}",
             params: {},
             headers: valid_headers
    end

    it "should return status 200" do
      expect(response.status).to eq 200
    end
 
    it "should delete the record" do
      expect(Game.all.count).to eq 2
    end
  end
end
