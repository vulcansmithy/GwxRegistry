class Oauth::ApplicationsController < Doorkeeper::ApplicationsController
  before_action :authenticate_request

  def index
    @applications = @current_user.oauth_applications
  end

  # only needed if each application must have some owner
  def create
    @application = Doorkeeper::Application.new(application_params)
    @application.owner = @current_user if Doorkeeper.configuration.confirm_application_owner?
    if @application.save
      flash[:notice] = I18n.t(:notice, :scope => [:doorkeeper, :flash, :applications, :create])
      redirect_to oauth_application_url(@application)
    else
      render :new
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
      render json: { error: "Unauthorized: Access is denied" },
             status: :unauthorized
    end
  end
end
