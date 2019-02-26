class Api::V1::PlayersController < Api::V1::BaseController
  before_action :check_current_user
  before_action except: %i[index show] do
    check_player_publisher_account(@current_user, "player")
  end
  before_action :set_player, only: %i[show edit update]

  def index
    @players = Player.all
    success_response(PlayerSerializer.new(@players).serialized_json)
  end

  def show
    success_response(PlayerSerializer.new(@player).serialized_json)
  end

  def create
    @player = @current_user.create_player(player_params)

    if @player.save
      success_response(PlayerSerializer.new(@player).serialized_json, :created)
    else
      error_response("Unable to create player account",
        @player.errors.full_messages, :unprocessable_entity)
    end
  end

  def edit
    render json: { player: PlayerSerializer.new(@player).serialized_json }
  end

  def update
    if @player.update(player_params)
      success_response(PlayerSerializer.new(@player).serialized_json)
    else
      error_response("Unable to update player account",
        @player.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def player_params
    params.permit(:user_id, :username)
  end

  def set_player
    unless @player = @current_user.player
    error_response("You don't have an existing player account",
                   "Player account does not exist",
                   :unprocessable_entity)
    end
  end
end
