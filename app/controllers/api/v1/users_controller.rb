class Api::V1::UsersController < Api::V1::BaseController
  before_action :initialize

  def create
    @user = User.create(user_params)
    @user.wallet_address = @account.address

    if @user.save
      message = 'User account successfully created'
    else
      message = @user.errors.full_messages
    end

    render json: {message: message, account: @account}
  end

  def show
    @user = User.find(params[:id])
    render json: {user: @user}
  end

  private

  def initialize
    @nem = NemService.new
    @account = @nem.generate_account
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :wallet_address)
  end
end
