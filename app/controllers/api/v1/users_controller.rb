class Api::V1::UsersController < Api::V1::BaseController

  # @TODO temporary disable authentication
=begin
  skip_before_action :authenticate_request, only: %i[edit profile_update show
                                                  account_update create index]
=end

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

  def show
    render json: { user: @user }
  end

  # POST  /users
  # POST  /users, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # POST  /users?version=1
  # POST  /v1/users
  def create
    @user = User.create(user_params)
    # @account = @nem.generate_account

    if @user.save && @account
      # @user.update(wallet_address: @account.address)
      response = {
        message: 'User created successfully',
        user: UserSerializer.new(@user).serialized_json,
        account: @account,
        status: :created
      }
      success_response(response, :created)
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
    render json: { user: @user}
  end

  def profile_update
    if @user.update(update_profile_params)
      response = { message: 'User profile successfully updated' }
    else
      response = { message: @user.errors.full_messages, status: :bad }
    end

    render json: response
  end

  def account_update
    if @user.update(update_account_params)
      response = {
                   message: 'User account successfully updated',
                   account: @account,
                   status: :ok
                 }
    else
      response = { message: @user.errors.full_messages }
    end

    render json: response
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
    params.require(:user).permit(:email, :password, :password_confirmation)
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
      response = { access_token: command.result, message: 'Login Successful' }
    else
      response = { message: command.errors, status: :unauthorized }
    end
    render json: response
  end
end
