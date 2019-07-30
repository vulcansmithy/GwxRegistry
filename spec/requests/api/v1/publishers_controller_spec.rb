require "rails_helper"

describe Api::V1::PublishersController, fake_name: true do
  before { mock_nem_service }

  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:user3) { create(:user) }
  let!(:publisher) { create(:publisher, user: user) }
  let!(:publisher2) { create(:publisher, user: user2) }
  let!(:valid_headers) { generate_jwt_headers(user) }
  let!(:valid_headers2) { generate_jwt_headers(user2) }
  let!(:valid_headers3) { generate_jwt_headers(user3) }
  let!(:games) { create_list(:game, 4, publisher: publisher) }

  let(:publisher_params) do
    {
      publisherName: "test_name",
      description: "Blah blah blah",
      walletAddress: "",
      userId: user.id
    }
  end

  describe "GET /publishers" do
    context "when publishers exists" do
      before do
        get "/v1/publishers",
            params: {}
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should return all publishers" do
        expect(json['data'].count).to eq 2
      end
    end
  end

  describe "POST /publishers" do
    context "when params are valid" do
      before do
        post "/v1/publishers",
            params: publisher_params.to_json,
            headers: valid_headers3
      end

      it "should return status 201" do
        expect(response.status).to eq 201
      end

      it "should return correct data of newly created account" do
        expect(json['data']['attributes']['publisherName']).to eq 'test_name'
      end
    end

    context "when params is invalid" do
      before do
        post "/v1/publishers",
            params: publisher_params.except(:publisherName).to_json,
            headers: valid_headers2
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end

    context "when user has already a publisher" do
      before do
        post "/v1/publishers",
            params: publisher_params.to_json,
            headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "GET /publishers/:id" do
    context "when account exists" do
      before do
        get "/v1/publishers/#{publisher.id}",
            params: {},
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end
    end

    context "when account does not exists" do
      before do
        get "/v1/publishers/-1",
            params: {},
            headers: valid_headers
      end

      it "should return status 400" do
        expect(response.status).to eq 400
      end
    end
  end

  describe "PUT /publishers/me" do
    context "when params are valid" do
      before do
        put '/v1/publishers/me',
            params: { publisherName: "new_name" }.to_json,
            headers: valid_headers
      end

      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should return updated data" do
        expect(json['data']['attributes']['publisherName']).to eq 'new_name'
      end
    end

    context "when params are invalid" do
      before do
        put '/v1/publishers/me',
            params: { publisherName: publisher2.publisher_name }.to_json,
            headers: valid_headers
      end

      it "should return status 422" do
        expect(response.status).to eq 422
      end
    end
  end

  describe "GET /publishers/me/games" do
    context "when games exists" do
      before do
        get '/v1/publishers/me/games',
            params: {},
            headers: valid_headers

      end
      it "should return status 200" do
        expect(response.status).to eq 200
      end

      it "should correct data" do
        expect(Game.all.count).to eq 4
      end
    end
  end
end
