module ExceptionHandler
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class DecodeError < StandardError; end
  class ExpiredSignature < StandardError; end
  class MissingToken < StandardError; end
  class UserVerified < StandardError; end

  included do
    rescue_from ExceptionHandler::AuthenticationError, with: :unauthorized
    rescue_from ExceptionHandler::DecodeError, with: :unauthorized
    rescue_from ExceptionHandler::ExpiredSignature, with: :unauthorized
    rescue_from ExceptionHandler::MissingToken, with: :unprocessable
    rescue_from ActiveRecord::RecordNotFound, with: :not_found
    rescue_from ExceptionHandler::UserVerified, with: :unprocessable
  end

  private

  def not_found(e)
    render json: { message: e.message }, status: not_found
  end

  def unprocessable(e)
   render json: { message: e.message }, status: :unprocessable_entity
  end

  def unauthorized(e)
    render json: { message: e.message }, status: :unauthorized
  end
end
