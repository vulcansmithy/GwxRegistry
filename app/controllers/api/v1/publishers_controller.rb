class Api::V1::PublishersController < Api::V1::BaseController
  before_action :initialize
  before_action :find_user

  def create
    @publisher = @user.create_publisher(publisher_params)
    @publisher.wallet_address = @account.address

    if @publisher.save
      message = 'Publisher account successfully created'
    else
      message = @user.errors.full_messages
    end
    render json: {message: message, account: @account}
  end

  def show
    render json: {publisher: @user.publisher}
  end

  private

  def initialize
    @nem = NemService.new
    @account = @nem.generate_account
  end

  def publisher_params
    params.require(:publisher).permit(:description, :wallet_address, :user_id)
  end

  def find_user
    @user = User.find(params[:publisher][:user_id])
  end
end
