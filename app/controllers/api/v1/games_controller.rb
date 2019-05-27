class Api::V1::GamesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  before_action :set_publisher, only: %i[create update show destroy]
  before_action :transform_params, only: :create
  before_action :set_game, except: %i[index create]

  def index
    @games = Game.all.paginate(page: params[:page])
    serialized_games = GameSerializer.new(@games).serializable_hash
    game_list = serialized_games.merge(pagination: pagination(@games))
    success_response game_list
  end

  def show
    success_response GameSerializer.new(@game).serialized_json
  end

  def create
    @game = @publisher.games.new game_params
    @game_application = GameApplication.new(
      name: @game.name,
      redirect_uri: "https://localhost:8080",
      owner: @current_user,
      game: @game
    )

    if @game_application.save && @game.save
      success_response AuthGameSerializer.new(@game, include: [:publisher, :game_application]).serialized_json, :created
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
    player_profile_list = serialized_player_profiles.merge(pagination: pagination(@player_profiles))
    success_response player_profile_list
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
