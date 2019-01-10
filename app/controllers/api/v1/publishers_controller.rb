class Api::V1::PublishersController < Api::V1::BaseController
  before_action :find_user

  def create
    @publisher = @user.create_publisher(publisher_params)
    if @publisher.save
      message = 'Publisher account successfully created'
    else
      message = @user.errors.full_messages
    end
    render json: {message: message}
  end

  def show
    render json: {user: @user.publisher}
  end

  private

  def publisher_params
    params.require(:publisher).permit(:description, :wallet_address, :user_id)
  end

  def find_user
    @user = User.find(params[:publisher][:user_id])
  end
end
