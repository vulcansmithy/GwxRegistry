class JsonWebToken
  SECRET_KEY = Rails.application.secret_key_base.to_s
  JWT_DECODE_ERROR = "JWT is invalid and cannot be decoded."
  JWT_EXPIRED_ERROR = "JWT is expired, please try logging in again!"
  JWT_VERIFICATION_ERROR = "JWT cannot be verified."
  
  class << self
    def encode(payload, exp = 6.hours.from_now)
      payload[:exp] = exp.to_i
      token = JWT.encode(payload, SECRET_KEY)
    end

    def decode(token)
      decoded_token = JWT.decode(token, SECRET_KEY)
      nil
    rescue JWT::ExpiredSignature then JWT_EXPIRED_ERROR
    rescue JWT::VerificationError then JWT_VERIFICATION_ERROR
    rescue JWT::DecodeError then JWT_DECODE_ERROR
      OpenStruct.new(payload: decoded_token&.first, error_message: error_message)
    end
  end
end
