module Requests
  module JsonHelpers
    def json
      JSON.parse(response.body)
    end

    def jsonify(serializer, object)
      JSON.parse(serializer.new(object).to_json)
    end
  end

  module HeaderHelpers
    def generate_headers(user)
      token = JsonWebToken.encode(user_id: user.id)
      {
        'Content-Type': 'application/json',
        'Authorization': "Basic #{token}"
      }
    end
  end
end
