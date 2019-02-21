class ApplicationController < ActionController::API
  before_action :authenticate_request

  attr_reader :current_user

  include ExceptionHandler

  def index
    render json: { message: OK }, status: :ok
  end

  private

  def authenticate_request
    begin
      @current_user = AuthorizeApiRequest.call(request.headers).result
    rescue
      render json: { error: "Unauthorized: Access is denied" }, status: :unauthorized
    end
  end
end
