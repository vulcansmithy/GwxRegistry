class Api::V1::ServicesController <  Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_request

  def public_key
    success_response({ public_key: PublicKeyEncryptionService.new.public_key })
  end
end
