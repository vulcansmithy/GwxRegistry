class Api::V1::PublishersController < Api::V1::BaseController
  before_action :params_transform, only: [:create]
  before_action :check_current_user
  before_action only: [:create] do
    check_player_publisher_account(@current_user, "publisher")
  end
  before_action :set_publisher, only: %i[edit update show]

  def index
    @publishers = Publisher.all
    success_response(PublisherSerializer.new(@publishers).serialized_json)
  end

  def show
    success_response(PublisherSerializer.new(@publisher).serialized_json)
  end

  def create
    @publisher = @user.create_publisher(publisher_params)

    if @publisher.save
      success_response(PublisherSerializer.new(@publisher).serialized_json, :created)
    else
      error_response("Unable to create publisher account",
        @publisher.errors.full_messages, :unprocessable_entity)
    end
  end

  def edit
    success_response(PublisherSerializer.new(@publisher).serialized_json)
  end

  def update
    if @publisher.update(publisher_params)
      success_response(PublisherSerializer.new(@publisher).serialized_json)
    else
      error_response("Unable to update publisher account",
        @user.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def publisher_params
    params.permit(:description, :wallet_address, :user_id, :publisher_name)
  end

  def set_publisher
    unless @publisher = @current_user.publisher
    error_response("You don't have an existing publisher account",
                   "Publisher account does not exist",
                   :unprocessable_entity)
    end
  end
end
