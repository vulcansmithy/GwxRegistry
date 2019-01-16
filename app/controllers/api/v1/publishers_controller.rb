class Api::V1::PublishersController < Api::V1::BaseController
  
  # @TODO temporary disable authentication
=begin
  skip_before_action :authenticate_request, only: [:edit, :update,
                                                   :publisher_update,
                                                   :create, :show]
=end
  
  before_action :initialization, only: [:create]
  before_action :find_user, only: [:create, :edit, :update, :publisher_update, :show]
  before_action :find_publisher, only: [:edit, :update, :publisher_update, :show]

  def index
    render json: { publishers: Publisher.all }
  end

  def show
    render json: { publisher: @publisher }
  end

  def create
    @publisher = @user.create_publisher(publisher_params)
    @account = @nem.generate_account

    if @publisher.save && @account
      @publisher.update(wallet_address: @account.address)
      response = { message:'Publisher account successfully created', account: @account }
    else
      response = { message: @user.errors.full_messages }
    end
    render json: response
  end

  def edit
    render json: { publisher: @publisher }
  end

  def update
    if @publisher.update(publisher_params)
      message = 'Publisher account successfully updated'
    else
      message = @publisher.errors.full_message
    end
    render json: { message: message }
  end

  def publisher_update
    if @publisher.update(publisher_params)
      message = 'Publisher account successfully updated'
    else
      message = @publisher.errors.full_message
    end
    render json: { message: message }
  end

  private

  def initialization
    @nem = NemService.new
    @node
  end

  def publisher_params
    params.require(:publisher).permit(:description, :wallet_address, :user_id)
  end

  def find_user
    @user = User.find(params[:publisher][:user_id])
  end

  def find_publisher
    @publisher = @user.publisher
  end
end
