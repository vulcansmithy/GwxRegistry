class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_request, only: %i[create login confirm]
  before_action :set_user, only: %i[show edit update resend_code]

  def index
    @users = User.all
    success_response(UserSerializer.new(@users).serialized_json)
  end

  def show
    success_response(UserSerializer.new(@user).serialized_json)
  end

  def create
    @user = User.create(user_params)
    if @user.save
      authenticate user_params[:email], user_params[:password]
    else
      error_response("Unable to create user account.", @user.errors, :unprocessable_entity)
    end
  end

  def confirm
    return unless params[:code]
    if user = User.find_by(confirmation_code: params[:code])
      if Time.now.utc > (user.confirmation_sent_at + 60.minutes)
        render json: { message: 'Expired confirmation code' }, status: :unprocessable_entity
        user.resend_confirmation!
      else user.confirm_account(params[:code])
        render json: { message: 'Confirmed' }, status: :ok
        user.confirm!
      end
    else
      render json: { message: 'Wrong confirmation code' }, status: :unprocessable_entity
    end
  end

  def resend_code
    raise_user_verified unless @current_user.confirmed_at.nil?
    @current_user.send_confirmation_code
    render json: { message: 'Sent' }, status: :ok
  end

  def update
    if @user.update(update_user_params)
      success_response(UserSerializer.new(@user).serialized_json)
    else
      error_response("Unable to update user profile",
                     @user.errors.full_messages,
                     :unprocessable_entity)
    end
  end

  def login
    authenticate params[:email], params[:password]
  end

  def test
    render json: {
      message: 'You have passed authentication and authorization test'
    }
  end

  private

  def set_user
    @user = User.find(params[:id])
    render json: { message: 'Unauthorized access' },
      status: :unauthorized unless @user == @current_user
  end

  def update_account_params
    params.permit(
      :password,
      :password_confirmation
    )
  end

  def update_user_params
    params.permit(
      :first_name,
      :last_name,
      :wallet_address,
      :pk
    )
  end

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :wallet_address,
      :pk,
      :mac_address,
      :email,
      :password,
      :password_confirmation
    )
  end

  def authenticate(email, password)
    begin
      command = AuthenticateUser.call(email, password)

      if command.success
        response = command.result
        response[:message] = 'Login Successful'

        success_response(response)
      end
    rescue
      error_response("Login Unsuccessful", "Invalid Credentials", :unauthorized)
    end
  end

  def raise_user_verified
    raise ExceptionHandler::UserVerified, "User has already been verified"
  end
end
