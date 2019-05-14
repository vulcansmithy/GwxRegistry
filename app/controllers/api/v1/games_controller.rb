class Api::V1::GamesController < Api::V1::BaseController
  def index
    @games = Games.all
    success_response(GameSerializer.new(@games).serialized_json)
  end

  def show
    @game = Game.find(params[:game_id])
    success_response(GameSerializer.new(@game).serialized_json)
  end

  def create
    @game = @current_user.create(game_params)
    if @game.save
      success_response(GameSerializer.new(@game).serialized_json)
    else
      error_response("Unable to create game", @game.errors.full_messages,
                     :unprocessable_entity)
    end
  end
  
  def edit
    success_response(GameSerializer.new(@game).serialized_json)
  end

  def update
    if @game.update(game_params)
      success_response(GameSerializer.new(@game).serialized_json)
    else
      error_response("Unable to update game details",
                     @game.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def game_params
    params.permit(:name, :description)
  end
end
