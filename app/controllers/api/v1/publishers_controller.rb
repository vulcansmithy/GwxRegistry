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
    @publishers = Publisher.all
    success_response(PublisherSerializer.new(@publishers).serialized_json)
  end

  def show
    success_response(PublisherSerializer.new(@publisher).serialized_json)
  end

  def create
    @publisher = @user.create_publisher(publisher_params)
    @account = @nem.generate_account

    if @publisher.save && @account
      @publisher.update(wallet_address: @account.address)
      response = {
        message: 'Publisher account successfully created',
        user: PublisherSerializer.new(@publisher).serialized_json,
        account: @account
      }
      success_response(response, :created)
    else
      error_response('Unable to create publisher account',
                     @publisher.errors.full_messages, :bad_request)
    end
  end

  def edit
    success_response(PublisherSerializer.new(@publisher).serialized_json)
  end

  def update
    if @publisher.update(publisher_params)
      response = {
        message: 'Publisher account successfully updated',
        publisher: PublisherSerializer.new(@publisher).serialized_json
      }
      success_response(response)
    else
      error_response('There is an error updating publisher account',
                     @user.errors.full_messages, :bad_request)
    end
  end

  private

  def initialization
    @nem = NemService.new
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
