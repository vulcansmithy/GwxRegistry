class Api::V1::ServicesController <  Api::V1::BaseController
  
  skip_before_action :doorkeeper_authorize!, only: %i[public_key] 
  skip_before_action :authenticate_request,  only: %i[public_key]

  def public_key
    success_response({ public_key: PublicKeyEncryptionService.new.registry_public_key })
  end
end
