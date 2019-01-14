class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_request, only: [:edit, :profile_update, :account_update]
  before_action :initialize, only: [:create]
  before_action :find_user, only: [:show, :edit,
                                   :profile_update, :account_update]

  def index
    @users = User.all
    render json: { users: @users }
  end

  def show
    render json: { user: @user }
  end

  def create
    @user = User.create(user_params)
    @user.wallet_address = @account.address

    if @user.save
      message = 'User account successfully created'
    else
      message = @user.errors.full_messages
    end

    render json: { message: message, account: @account }
  end

  def edit
    render json: { user: @user }
  end

  def update; end

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
  end

  private

  def initialize
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
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :wallet_address)
  end
end
