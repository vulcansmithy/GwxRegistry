class Api::V1::BaseController < ApplicationController

  def success_response(response_payload, status_code=:ok)
    render json: response_payload, status: status_code
  end
  
  def error_response(message, status_code)    
    render json: { message: message }, status: status_code
  end
  
end
