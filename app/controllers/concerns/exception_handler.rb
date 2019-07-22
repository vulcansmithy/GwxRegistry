module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class MissingToken < StandardError; end
  class UserVerified < StandardError; end
  class ExpiredCode < StandardError; end
  class WrongCode < StandardError; end
  class InvalidArgs < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized
    rescue_from ExceptionHandler::DecodeError, with: :unauthorized
    rescue_from ExceptionHandler::ExpiredSignature, with: :unauthorized
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ExceptionHandler::UserVerified, with: :unprocessable
    rescue_from ExceptionHandler::ExpiredCode, with: :unprocessable
    rescue_from ExceptionHandler::WrongCode, with: :unprocessable
    rescue_from ExceptionHandler::InvalidArgs, with: :bad_request
  end

  private

  def not_found(e)
    render json: { errors: e.message }, status: :not_found
  end

  def unprocessable(e)
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def unauthorized(e)
    render json: { errors: e.message }, status: :unauthorized
  end

  def bad_request(e)
    render json: { errors: e.message }, status: :bad_request
  end
end
