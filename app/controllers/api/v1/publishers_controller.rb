class Api::V1::PublishersController < Api::V1::BaseController

  before_action :set_user, only: [:create, :edit, :update, :publisher_update, :show]
  before_action :check_publisher, only: [:create]
  before_action :set_publisher, only: [:edit, :update, :publisher_update, :show]

  def index
    @publishers = Publisher.all
    success_response(PublisherSerializer.new(@publishers).serialized_json)
  end

  def show
    success_response(PublisherSerializer.new(@publisher).serialized_json)
  end

  def create
    @user = User.find(params[:publisher][:user_id])
    @publisher = @user.create_publisher(publisher_params)

    if @publisher.save
      success_response(PublisherSerializer.new(@publisher).serialized_json, :created)
    else
      error_response("Unable to create publisher account",
        @publisher.errors.full_messages, :bad_request)
    end
  end

  def edit
    success_response(PublisherSerializer.new(@publisher).serialized_json)
  end

  def update
    if @publisher.update(publisher_params)
      success_response(PublisherSerializer.new(@publisher).serialized_json)
    else
      error_response("There is an error updating publisher account",
        @user.errors.full_messages, :bad_request)
    end
  end

  private

  def publisher_params
    params.require(:publisher).permit(:description, :wallet_address, :user_id, :publisher_name)
  end

  def set_user
    @user = User.find(params[:publisher][:user_id])
  end

  def set_publisher
    @publisher = @user.publisher
  end

  def check_publisher
    @user = User.find(params[:publisher][:user_id])
    @user.errors.add(:base, "publisher account already exist")
    error_response('Publisher account already exist', @user.errors.full_messages, :bad_request) if @user.publisher
  end
end
