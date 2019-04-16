class Api::V1::ServicesController <  Api::V1::BaseController
  
  skip_before_action :authenticate_request, only: %i[public_key]
  
  def public_key
    success_response({ public_key: PublicKeyEncryptionService.new.public_key })
  end

end
