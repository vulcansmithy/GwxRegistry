class Api::V1::UsersController < Api::V1::BaseController

  # @TODO temporary disable authentication
  # skip_before_action :authenticate_request, only: %i[edit profile_update show
  #                                                account_update create index login]
  skip_before_action :authenticate_request, only: %i[create login]

  before_action :find_user, only: %i[show profile_update account_update]

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
    if @user.save
      success_response(UserSerializer.new(@user).serialized_json,  :created)
    else
      error_response("Unable to create a new User account.", @user.errors, :bad_request)
    end
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
      error_response("User not found",
        "Passed 'id' does not match to any existing User",
        :not_found)
    end

    # update the user
    if @user.update(update_profile_params)
      success_response(UserSerializer.new(@user).serialized_json)
    else
      error_response("Unable to update user profile", @user.errors.full_messages, :bad_request)
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
      error_response("User not found",
        "Passed 'id' does not match to any existing User",
        :not_found)
    end

    # update the user
    if @user.update(update_account_params)
      success_response(UserSerializer.new(@user).serialized_json)
    else
      error_response("Unable to update user account", @user.errors.full_messages, :bad_request)
    end
  end

  # POST  /users/login
  # POST  /users/login, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # POST  /users/login?version=1
  # POST  /v1/users/login
  def login
    authenticate params[:email], params[:password]
  end

  def test
    message = @user.errors.full_messages
    render json: { message: message, account: @account }
  end


  private

  def find_user
    @user = User.find(params[:id])
  end

  def update_profile_params
    params.require(:user).permit(:first_name, :last_name, :wallet_address)
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
      :wallet_address,
      :email,
      :password,
      :password_confirmation
    )
  end

  def authenticate(email, password)
    command = AuthenticateUser.call(email, password)

    if command.success
      success_response({ access_token: command.result, message: "Login Successful" })
    else
      error_response("Login Unsuccessful", command.errors, :unauthorized)
    end
  end

end
