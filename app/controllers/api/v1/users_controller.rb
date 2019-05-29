class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_request, only: %i[create login confirm forgot update]
  # before_action :doorkeeper_authorize!, except: %i[create login confirm update show forgot]
  # skip_before_action :doorkeeper_authorize!
  before_action :check_current_user, only: %i[update update_password]
  before_action :transform_params, only: %i[create update update_password send_notification]
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
    wallet = Wallet.where(wallet_address: params[:wallet_address], account_type: "User")
    user = wallet[0].account
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

  def forgot
    if params[:email].blank?
      error_response('', "Email can't be blank", :unprocessable_entity)
    end

    user = User.find_by(email: params[:email])

    if user.present?
      user.reset_password!
      render json: { message: 'Sent' }, status: :ok
    else
      error_response('', 'Email address not found', :not_found)
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
      rails_env: Rails.env,
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

  def update_user_params
    params.permit(
      :first_name,
      :last_name,
      :wallet_address,
      :pk,
      :device_token,
      :password,
      :password_confirmation
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
      pk: params[:pk]
    )
  end

  def raise_wrong_code
    raise ExceptionHandler::WrongCode, "Wrong confirmation code"
  end

  def raise_user_verified
    raise ExceptionHandler::UserVerified, "User has already been verified"
  end
end
