class Api::V1::Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  before_action :authenticate_request

  def index
    @applications = @current_user.oauth_applications
    success_response(@applications)
  end

  # only needed if each application must have some owner
  def create
    @application = Doorkeeper::Application.new(application_params)
    @application.owner = @current_user if Doorkeeper.configuration.confirm_application_owner?
    if @application.save
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
      render json: { data: @application },
                    status: :created
    else
      render json: { error: 'Error in creating application',
                     message: @application.errors.full_messages },
                    status: :unprocessable_entity
    end
  end

  private

  def application_params
    params.permit(
      :name,
      :redirect_uri,
      :scopes,
      :confidential,
      :uid,
      :secret
    )
  end

  def authenticate_request
    begin
      @current_user = AuthorizeApiRequest.call(request.headers).result
    rescue
      render json: { error: 'Unauthorized: Access is denied' },
             status: :unauthorized
    end
  end
end
