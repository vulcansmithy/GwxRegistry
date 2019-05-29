class Api::V1::GamesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_request, only: %i[index show]
  before_action :set_publisher, only: %i[create update destroy]
  before_action :transform_params, only: :create
  before_action :set_game, except: %i[index create]

  def index
    @games = Game.all.paginate(page: params[:page])
    serialized_games = GameSerializer.new(@games).serializable_hash
    success_response paginate_result(serialized_games, @games)
  end

  def show
    @game = Game.find params[:id]
    success_response GameSerializer.new(@game).serialized_json
  end

  def create
    @game = @publisher.games.new game_params
    @game.category_ids = params[:categories]
    @game_application = GameApplication.new(
      name: @game.name,
      redirect_uri: "https://localhost:8080",
      owner: @current_user,
      game: @game
    )

    if @game_application.save && @game.save
      success_response PublisherPreviewGameSerializer.new(@game, include: [:publisher, :game_application]).serialized_json, :created
    else
      error_response 'Unable to create game',
                     @game.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def update
    if @game.update(game_params)
      success_response GameSerializer.new(@game).serialized_json
    else
      error_response 'Unable to update game details',
                     @game.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def destroy
    if @game.destroy
      render status: :no_content
    else
      error_response 'Unable to delete game',
                     @game.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def player_profiles
    @player_profiles = @game.player_profiles.paginate(page: params[:page])
    serialized_player_profiles = PlayerProfileSerializer.new(@player_profiles).serializable_hash
    success_response paginate_result(serialized_player_profiles, @player_profiles)
  end

  private

  def game_params
    params.permit(:name, :description)
  end

  def set_publisher
    @publisher = @current_user.publisher
    unless @publisher
      error_response('', 'Publisher account does not exist', :unauthorized)
    end
  end

  def set_game
    @game = @publisher.games.find params[:id]
  end
end
