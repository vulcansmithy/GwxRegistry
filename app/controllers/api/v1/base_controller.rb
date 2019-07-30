class Api::V1::BaseController < ApplicationController
  # before_action :doorkeeper_authorize!
  before_action :authenticate_request

  attr_reader :current_user

  include ExceptionHandler

  def index
    render json: { message: OK }, status: :ok
  end

  def success_response(response_payload, status_code = :ok)
    render json: response_payload, status: status_code
  end

  def error_response(message, errors, status_code)
    render json: { message: message, errors: errors }, status: status_code
  end

  private

  def authenticate_request
    begin
      @current_user = AuthorizeApiRequest.call(request.headers).result
    rescue
      render json: { error: "Unauthorized: Access is denied" },
             status: :unauthorized
    end
  end

  def check_player_publisher_account(user, account)
    return unless user.send("#{account}")
    error_response("Unable to create account",
                   "#{account.capitalize} account already exist",
                   :unprocessable_entity)
  end

  def check_current_user
    raise ExceptionHandler::AuthenticationError,
      'Unauthorized: Access is denied' unless
      @current_user == User.find(params[:user_id] || params[:id])
  end

  def transform_params
    params.transform_keys!(&:underscore)
  end
end
