class Api::V1::AuthController < Api::V1::BaseController
  # skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_request, only: %i[login register confirm forgot]
  before_action :transform_params, only: %i[update notify]
  before_action :set_recipient, only: :notify
  before_action :validate_email, only: :forgot

  def login
    authenticate params[:email], params[:password]
  end

  def register
    @user = User.new(user_params)
    if @user.save
      authenticate user_params[:email], user_params[:password]
    else
      error_response "Unable to create user account.",
                     @user.errors,
                     :unprocessable_entity
    end
  end

  def forgot
    user = User.find_by(email: params[:email])
    if user.present?
      user.reset_password!
      render json: { message: 'Sent' }, status: :ok
    else
      error_response('', 'Email address not found', :not_found)
    end
  end

  def me
    success_response UserSerializer.new(
      @current_user,
      include: [:publisher, :player_profiles, :games]
    ).serialized_json
  end

  def confirm
    if user = User.find_by(confirmation_code: params[:code])
      render json: { message: 'Confirmed' }, status: :ok if user.confirm_account(params[:code])
    else
      raise_wrong_code
    end
  end

  def resend
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

  def update_password
    if @current_user.update_password(update_user_params)
      success_response(UserSerializer.new(@current_user).serialized_json)
    else
      error_response("Unable to update password",
                     @current_user.errors.full_messages, :unprocessable_entity)
    end
  end

  def notify
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
      :password_confirmation,
      :avatar
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
      :password_confirmation,
      :avatar
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

  def validate_email
    if params[:email].blank?
      error_response('', "Email can't be blank", :bad_request)
    end
  end

  def raise_wrong_code
    raise ExceptionHandler::WrongCode, "Wrong confirmation code"
  end

  def raise_user_verified
    raise ExceptionHandler::UserVerified, "User has already been verified"
  end
end
