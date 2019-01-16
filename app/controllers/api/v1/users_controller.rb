class Api::V1::UsersController < Api::V1::BaseController

  # @TODO temporary disable authentication
=begin
  skip_before_action :authenticate_request, only: [:edit, :profile_update,
                                                   :account_update, :show,
                                                   :create, :index]
=end
  
# before_action :initialization, only: [:create]
  before_action :find_user,      only: [:show, :edit,
                                   :profile_update, :account_update]

  # GET  /users
  # GET  /users, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # GET  /users?version=1
  # GET  /v1/users 
  def index
    @users = User.all
    success_response(@users)
  end

  def show
    render json: { user: @user }
  end

  # POST  /users
  # POST  /users, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # POST  /users?version=1
  # POST  /v1/users 
  def create
    @user = User.create(user_params)
#   @user.wallet_address = @account.address

    if @user.save
      success_response(@users, :created)
    else
      error_response("Unable to create a new User.", @user.errors, :bad_request)
    end 
  end
  
  def register
    @user = User.create(user_params)
    @user.wallet_address = @account.address

    if @user.save
      response = { message: 'User created successfully' }
      render json: response, status: :created 
    else
      render json: @user.errors, status: :bad
    end 
  end  

  def login
    authenticate params[:email], params[:password]
  end

  def test 
    message = @user.errors.full_messages

    render json: { message: message, account: @account }
  end

  def edit
    render json: { user: @user }
  end

  def profile_update
    if @user.update(update_profile_params)
      message = 'User profile successfully updated'
    else
      message = @user.errors.full_messages
    end
  end

  def account_update
    if @user.update(update_account_params)
      message = 'User profile successfully updated'
    else
      message = @user.errors.full_messages
    end

    render json: { message: message, account: @account }, status: :ok
  end

  private

  def initialization
    @nem = NemService.new
    @account = @nem.generate_account
  end

  def find_user
    @user = User.find(params[:id])
  end

  def update_profile_params
    params.require(:user).permit(:first_name, :last_name)
  end

  def update_account_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def user_params
    params.require(:user).permit(
      :first_name, 
      :last_name, 
      :email, 
      :password, 
      :password_confirmation)
  end
  
  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      render json: {
        access_token: command.result,
        message: 'Login Successful'
      }
    else
      render json: { error: command.errors }, status: :unauthorized
    end
  end
end
