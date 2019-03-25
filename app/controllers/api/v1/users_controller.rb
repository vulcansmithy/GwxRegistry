class Api::V1::UsersController < Api::V1::BaseController
  before_action :doorkeeper_authorize!, except: %i[create login confirm edit update show]
  before_action :check_current_user, only: %i[edit update show]
  before_action :transform_params, only: %i[create edit update send_notification]
  before_action :set_recipient, only: :send_notification

  def index
    @users = User.all
    success_response(UserSerializer.new(@users).serialized_json)
  end

  def show
    success_response(UserSerializer.new(@current_user).serialized_json)
  end

  def create
    @user = User.create(user_params)
    if @user.save
      authenticate user_params[:email], user_params[:password]
    else
      error_response("Unable to create user account.", @user.errors,
                     :unprocessable_entity)
    end
  end

  def find_player
    user = User.find_by(wallet_address: params[:wallet_address])
    success_response(UserSerializer.new(user).serialized_json)
  end

  def confirm
    if user = User.find_by(confirmation_code: params[:code])
      render json: { message: 'Confirmed' }, status: :ok if user.confirm_account(params[:code])
    else
      raise_wrong_code
    end
  end

  def resend_code
    if @current_user.resend_mail
      render json: { message: 'Sent' }, status: :ok
    else
      raise_user_verified
    end
  end

  def update
    if @current_user.update(update_user_params)
      user_wallet if @current_user.wallet.nil? &&
                     params[:wallet_address] && params[:pk]
      success_response(UserSerializer.new(@current_user).serialized_json)
    else
      error_response("Unable to update user profile",
                     @current_user.errors.full_messages, :unprocessable_entity)
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

  def send_notification
    @fcm = FCMService.new
    if @fcm.notify([@recipient.device_token], notification_params[:options])
      success_response({ message: 'Notification sent' })
    else
      error_response('Failure on sending notifications', {}, :unprocessable_entity)
    end
  end

  private

  def set_recipient
    @recipient = User.find_by(wallet_address: params[:wallet_address])
  end

  def notification_params
    params.permit(:wallet_address, { :options => {} })
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
      :pk,
      :device_token
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

  def user_wallet
    @current_user.create_wallet(
      wallet_address: params[:wallet_address],
      encrypted_pk: @current_user.encrypted_pk,
      encrypted_pk_iv: @current_user.encrypted_pk_iv
    )
  end

  def raise_wrong_code
    raise ExceptionHandler::WrongCode, "Wrong confirmation code"
  end

  def raise_user_verified
    raise ExceptionHandler::UserVerified, "User has already been verified"
  end
end
