class Api::V2::PlayersController < Api::V2::BaseController
  before_action :transform_params, only: :create
  before_action :check_current_user, except: %i[index show create my_player]
  before_action only: :create do
    check_player_publisher_account(@current_user, "player")
  end

  def index
    @players = Player.all
    success_response(PlayerSerializer.new(@players).serialized_json)
  end

  def show
    @player = Player.find(params[:user_id])
    success_response(PlayerSerializer.new(@player).serialized_json)
  end

  def my_player
    success_response(PlayerSerializer.new(@current_user.player).serialized_json)
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
    @player = @current_user.player
    unless @player
      error_response("You don't have an existing player account",
                     "Player account does not exist", :not_found)
    end
  end
end
