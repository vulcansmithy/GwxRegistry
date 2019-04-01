class Api::V2::ServicesController <  Api::V2::BaseController
  
  skip_before_action :authenticate_request, only: %i[public_key]
  
  def public_key
    decoded_private_key = Base64.decode64(Rails.application.secrets.registry_private_key)
    private_key         = RbNaCl::PrivateKey.new(decoded_private_key)
    public_key          = Base64.encode64(private_key.public_key)

    success_response({ public_key: public_key })
  end

end
