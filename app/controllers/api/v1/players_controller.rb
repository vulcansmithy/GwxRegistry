class Api::V1::PlayersController < Api::V1::BaseController

  before_action :set_user, only: %i[create show edit update check_player]
  before_action :check_player, only: [:create]
  before_action :set_player, only: %i[show edit update]

  # GET  /players
  # GET  /players, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # GET  /players?version=1
  # GET  /v1/players
  def index
    @players = Player.all
    success_response(PlayerSerializer.new(@players).serialized_json)
  end

  # GET  /players/:id
  # GET  /players/:id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # GET  /players/:id?version=1
  # GET  /v1/players/:id
  def show
    success_response(PlayerSerializer.new(@player).serialized_json)
  end

  # POST  /players
  # POST  /players, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # POST  /players?version=1
  # POST  /v1/players
  def create
    @player = @user.create_player(player_params)

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

  # PATCH /players/:player_id
  # PATCH /players/:player_id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # PATCH /players/:player_id?version=1
  # PATCH /players/:player_id
  #
  # PUT   /players/:player_id
  # PUT   /players/:player_id, {}, { "Accept" => "application/vnd.gameworks.io; vesion=1" }
  # PUT   /players/:player_id?version=1
  # PUT   /players/:player_id
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

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_player
    @player = @user.player
    @user.errors.add(:base, "Player account does not exist")
    error_response("You don't have an existing player account", @user.errors.full_messages, :unprocessable_entity) unless @player
  end

  def check_player
    @user.errors.add(:base, "player account already exist")
    error_response('Player account already exist', @user.errors.full_messages, :unprocessable_entity) if @user.player
  end
end
