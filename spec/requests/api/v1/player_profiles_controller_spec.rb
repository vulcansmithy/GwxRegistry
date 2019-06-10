require "rails_helper"

describe Api::V1::PlayerProfilesController, fake_name: true do
  before { mock_nem_service }

  let!(:user) { create(:user) }
  let!(:player_user) { create(:user) }
  let!(:other_player_user) { create(:user) }
  let!(:publisher_user) { create(:publisher, user: user) }
  let!(:game) { create(:game, publisher: publisher_user) }
  let!(:player_profile) { build(:player_profile, user: player_user, game: game) }
  let!(:other_player_profile) { create(:player_profile, user: other_player_user, game: game) }
  let!(:valid_headers) { generate_headers(player_user) }
  let!(:other_valid_headers) { generate_headers(other_player_user) }

  let!(:player_profile_params) do
    {
      user_id: player_user.id,
      username: player_profile.username,
      game_id: game.id
    }
  end

  describe "GET /player_profiles" do
    before do
      get "/v1/player_profiles",
          params: {},
          headers: valid_headers
    end

    it "should return status 200" do
      expect(response.status).to eq 200
    end

    it "should return correct results" do
      expect(json['data'].count).to eq 1
    end
  end

  describe "POST /player_profiles" do
    context "when player_profile params are valid" do
      before do
        post "/v1/player_profiles",
             params: player_profile_params.to_json,
             headers: valid_headers
      end

      it "should return status 201" do
        expect(response.status).to eq 201
      end

      it "should return correct result" do
        expect(json['data']['attributes']['username']).to eq player_profile.username
      end
    end

    context "when player_profile params are invalid" do
      before do
        post "/v1/player_profiles",
             params: player_profile_params.except(:username).to_json,
             headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "GET /player_profiles/:id" do
    context "when player_profile exists" do
      before do
        get "/v1/player_profiles/#{player_profile.id}",
            params: {},
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end
    end

    context "when action doesn't exists" do
      before do
        get "/v1/player_profiles/-1",
            params: {},
            headers: valid_headers
      end

      it "should return status 404" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "PUT /player_profiles/:id" do
    context "when player_profile params are valid" do
      before do
        put "/v1/player_profiles/#{other_player_profile.id}",
            params: { username: "username" }.to_json,
            headers: other_valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should update the record" do
        expect(json['data']['attributes']['username']). to eq "username"
      end
    end

    context "when player_profile params are invalid" do
      before do
        put "/v1/player_profiles/#{other_player_profile.id}",
            params: { username: nil }.to_json,
            headers: other_valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE /player_profiles/:id" do
    before do
      delete "/v1/player_profiles/#{other_player_profile.id}",
             params: {},
             headers: other_valid_headers
    end

    it "should return status 200" do
      expect(response.status).to eq 200
    end

    it "should delete the record" do
      expect(PlayerProfile.all.count).to eq 0
    end
  end
end
