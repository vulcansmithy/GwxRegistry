require "rails_helper"

describe Api::V1::PlayerProfilesController do
  let!(:user) { create(:user) }
  let!(:publisher_user) { create(:publisher, user: user) }
  let!(:game) { create(:game, publisher: publisher_user) }
  let!(:player_profile) { create(:player_profile, game: game) }
  let!(:valid_headers) { generate_headers(user) }

  let!(:profile_params) do
    { username: player_profile.username }
  end

  describe "GET /player_profiles/" do
    before do
      get "/v1/player_profiles/",
          params: {},
          headers: valid_headers
    end

    it "should return status 200" do
      expect(response.status).to eq 200
    end
  end

  describe "POST /player_profiles/" do
    context "when profile_params are valid" do
      before do
        post "/v1/player_profiles",
             params: profile_params.to_json,
             headers: valid_headers
      end

      it "should return status 201" do
        expect(response.status).to eq 201
      end

      it "should return correct result" do
        expect(json['data']['attributes']['username']).to eq player_profile.username
      end
    end

    context "when profile params are invalid" do
      before do
        post "/v1/player_profiles",
             params: profile_params.except(:username).to_json,
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
        get "/v1/player_profiles/#{PlayerProfile.last.id}",
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
        put "/v1/player_profiles/#{PlayerProfile.last.id}",
            params: { username: "New name" }.to_json,
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should update the record" do
        expect(json['data']['attributes']['username']). to eq "New name"
      end
    end

    context "when player_profile params are invalid" do
      before do
        put "/v1/player_profiles/#{PlayerProfile.last.id}",
          params: { username: nil }.to_json,
          headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "DELETE /player_profiles/:id" do
    before do
      delete "/v1/player_profiles/#{PlayerProfile.last.id}",
             params: {},
             headers: valid_headers
    end

    it "should return status 204" do
      expect(response.status).to eq 204
    end
 
    it "should delete the record" do
      expect(PlayerProfile.all.count).to eq 0
    end
  end
end
