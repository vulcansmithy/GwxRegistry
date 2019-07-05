class JsonWebToken
  class << self
    JWT_DECODE_ERROR = "JWT is invalid and cannot be decoded.".freeze
    JWT_EXPIRED_ERROR = "JWT is expired, please try logging in again!".freeze
    JWT_VERIFICATION_ERROR = "JWT cannot be verified.".freeze
    
    def encode(payload, exp: 6.hours.from_now)
      payload[:exp] = exp.to_i
      token = JWT.encode(payload, jwt_secret)
    end

    def decode(token:)
      error_message = begin
                        decoded_token  = JWT.decode(token, jwt_secret, true)
                        nil
                      rescue JWT::ExpiredSignature then JWT_EXPIRED_ERROR
                      rescue JWT::VerificationError then JWT_VERIFICATION_ERROR
                      rescue JWT::DecodeError then JWT_DECODE_ERROR
                      end
      OpenStruct.new(payload: decoded_token&.first, error_message: error_message)
    end

    private
    
    def jwt_secret
      Rails.application.secret_key_base
    end
  end
end
