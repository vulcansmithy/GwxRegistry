class Api::V1::PublishersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_request, only: :index
  before_action :set_publisher, only: %i[update games]
  before_action :transform_params, only: %i[create update]

  def index
    @publishers = Publisher.all.paginate(page: params[:page])
    serializable_publishers = PublisherSerializer.new(@publishers).serialized_hash
    publisher_list = serialized_publishers.merge(pagination: pagination(@publishers)) 
    success_response publisher_list
  end

  def show
    @publisher = Publisher.find params[:id]
    success_response PublisherSerializer.new(@publisher).serialized_json
  end

  def create
    @publisher = @current_user.create_publisher(publisher_params)

    if @publisher.save
      success_response PublisherSerializer.new(@publisher).serialized_json,
                       :created
    else
      error_response 'Unable to create publisher account',
                     @publisher.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def update
    if @publisher.update(publisher_params)
      success_response PublisherSerializer.new(@publisher).serialized_json
    else
      error_response 'Unable to update publisher account',
                     @publisher.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def games
    @games = @publisher.games.paginate(page: params[:page])
    serialized_games = PublisherPreviewGameSerializer.new(@games, include: [:game_application]).serializable_hash
    game_list = serialized_games.merge(pagination: pagination(@games))
    success_response game_list
  end

  private

  def publisher_params
    params.permit(:description, :wallet_address, :user_id, :publisher_name)
  end

  def set_publisher
    @publisher = @current_user.publisher
    unless @publisher
      error_response "You don't have an existing publisher account",
                     'Publisher account does not exist',
                     :not_found
    end
  end
end
