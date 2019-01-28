class ApplicationController < ActionController::API

  # @TODO temporary disabled until all the rspec test for the endpoints are implemented and passing
  before_action :authenticate_request

  attr_reader :current_user

  include ExceptionHandler

  private

  def authenticate_request
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end
end
