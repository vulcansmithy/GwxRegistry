class Api::V2::AuthController < Api::V2::BaseController
  
  include WalletPkSecurity::Splitter
  
  skip_before_action :authenticate_request, except: %i[me resend update update_password notify]
  before_action :transform_params, only: %i[update notify]
  before_action :set_recipient, only: :notify
  before_action :validate_email, only: :forgot

  def login
    authenticate params[:email], params[:password]
  end

  def console_login
    authenticate_by_wallet params[:wallet_address]
  end

  def ensure_access
    if params[:access_token] =~ /Basic (.+)/
      token = Regexp.last_match(1)
      decoded_token = JsonWebToken.decode(token: token)
      if decoded_token.error_message.present?
        error_response('', decoded_token.error_message, :unauthorized)
      else
        render json: { message: 'Active' }, status: :ok
      end
    else
      render json: { message: 'Wrong token' }, status: :unprocessable_entity 
    end
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

  def register_with_wallet
    @user_form = UserWithWalletForm.new(user_params)
    if @user_form.save
      authenticate @user_form.email, @user_form.password
    else
      error_response "Unable to create user account.",
                     @user_form.errors,
                     :unprocessable_entity
    end
  end

  def forgot
    user = User.find_by!(email: params[:email])
    user.reset_password!

    render json: { message: 'Sent' }, status: :ok
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
      :avatar,
      :username
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
      :avatar,
      :username
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

  def authenticate_by_wallet(wallet_address)
    if params[:wallet_address].blank?
      error_response('', "Wallet address can't be blank", :bad_request)
    else
      begin
        command = AuthenticateWallet.call(wallet_address)
        if command.success
          response = command.result
          response[:message] = 'Login successful'
          success_response(response)
        end
      rescue
        error_response("Login unsuccessful", "Invalid wallet_address", :unauthorized)
      end
    end
  end

  def user_wallet
    result = split_up_and_distribute(params[:wallet_address], params[:pk])
    
    @current_user.create_wallet(
      wallet_address: params[:wallet_address],
      pk: params[:pk],
      custodian_key: result[:shards][0]
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
