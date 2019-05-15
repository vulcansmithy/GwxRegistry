class Api::V1::GamesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  before_action :set_publisher, only: :create
  before_action :set_game, only: %i[show update]
  before_action :transform_params, only: :create

  def index
    @games = Game.all
    success_response(GameSerializer.new(@games).serialized_json)
  end

  def show
    success_response(GameSerializer.new(@game).serialized_json)
  end

  def create
    @game = @publisher.games.new(game_params)
    if @game.save
      success_response(GameSerializer.new(@game).serialized_json)
    else
      error_response('Unable to create game', @game.errors.full_messages,
                     :unprocessable_entity)
    end
  end

  def update
    if @game.update(game_params)
      success_response(GameSerializer.new(@game).serialized_json)
    else
      error_response('Unable to update game details',
                     @game.errors.full_messages, :unprocessable_entity)
    end
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
    @game = @publisher.games.find(params[:id])
  end
end
