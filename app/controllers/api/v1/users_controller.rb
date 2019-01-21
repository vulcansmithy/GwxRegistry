class Api::V1::UsersController < Api::V1::BaseController
  
  DISABLE_WALLET_CREATION = true

  # @TODO temporary disable authentication
  # skip_before_action :authenticate_request, only: %i[edit profile_update show
  #                                                account_update create index]

  before_action :initialization, only: [:create]
  before_action :find_user, only: %i[show edit profile_update account_update]

  # GET  /users
  # GET  /users, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # GET  /users?version=1
  # GET  /v1/users
  def index
    @users = User.all
    success_response(UserSerializer.new(@users).serialized_json)
  end

  # GET  /users/:id
  # GET  /users/:id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # GET  /users/:id?version=1
  # GET  /v1/users/:id
  def show
    success_response(UserSerializer.new(@user).serialized_json)
  end

  # POST  /users
  # POST  /users, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # POST  /users?version=1
  # POST  /v1/users
  def create

    @user = User.create(user_params)
    
    @account = @nem.generate_account unless DISABLE_WALLET_CREATION

    if @user.save 
      
      unless DISABLE_WALLET_CREATION 
        @user.update(wallet_address: @account.address)
      end
      
      success_response(UserSerializer.new(@user).serialized_json,  :created)
    else
      error_response("Unable to create a new User.", @user.errors, :bad_request)
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

  # PATCH /users/profile_update/:id
  # PATCH /users/profile_update/:id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # PATCH /users/profile_update/:id?version=1
  # PATCH /v1/users/profile_update/:id
  #
  # PUT   /users/profile_update/:id
  # PUT   /users/profile_update/:id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # PUT   /users/profile_update/:id?version=1
  # PUT   /v1/users/profile_update/:id
  def profile_update

    # retrieve the existing user by means of the passed "id"
    @user = User.where(id: params[:id]).first
    if @user.nil?
      error_response("User not found", nil, :not_found)
    end

    # update the user
    @user.update(update_profile_params)
    if @user.changes.empty?
      error_response("Unable to update user profile", @user.errors.full_messages, :bad_request)
    else
      success_response(UserSerializer.new(@user).serialized_json)
    end
  end

  # PATCH /users/account_update/:id
  # PATCH /users/account_update/:id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # PATCH /users/account_update/:id?version=1
  # PATCH /v1/users/account_update/:id
  #
  # PUT   /users/account_update/:id
  # PUT   /users/account_update/:id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # PUT   /users/account_update/:id?version=1
  # PUT   /v1/users/account_update/:id
  def account_update

    # retrieve the existing user by means of the passed "id"
    @user = User.where(id: params[:id]).first
    if @user.nil?
      error_response("User not found", nil, :not_found)
    end  
    
    # update the user
    @user.update(update_account_params)
    if @user.changes.empty?
      error_response("Unable to update user account", @user.errors.full_messages, :bad_request)
    else
      success_response(UserSerializer.new(@user).serialized_json)
    end  
  end


  private

  def initialization
    @nem = NemService.new
  end

  def find_user
    @user = User.find(params[:id])
  end

  def update_profile_params
    params.require(:user).permit(:first_name, :last_name)
  end

  def update_account_params
    params.require(:user).permit(
      :email, 
      :password, 
      :password_confirmation)
  end

  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success?
      response = { access_token: command.result, message: "Login Successful" }
    else
      response = { message: command.errors, status: :unauthorized }
    end
    render json: response
  end
end
