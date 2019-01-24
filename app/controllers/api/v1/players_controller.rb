class Api::V1::PlayersController < Api::V1::BaseController

  # @TODO temporary disable authentication
=begin
  skip_before_action :authenticate_request, only: [:edit, :create, :update, :find_user, :show]
=end

  before_action :find_user, only: [:show, :edit, :update, :check_player]
  before_action :check_player, only: [:create]
  before_action :find_player, only: [:show, :edit, :update]

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
    @user = User.find(params[:player][:user_id])
    @player = @user.create_player(player_params)
    if @player.save
      success_response(PlayerSerializer.new(@player).serialized_json, :created)
    else
      error_response('Unable to create player account',
                     @player.errors.full_messages, :bad_request)
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
      error_response('Unable to update player account',
                     @player.errors.full_messages, :bad_request)
    end
  end

  private

  def player_params
    params.require(:player).permit(:user_id, :username, :wallet_address)
  end

  def find_user   
    @user = User.find(params[:user_id])
  end

  def find_player
    @player = @user.player
  end

  def check_player
    @user = User.find(params[:player][:user_id])
    @user.errors.add(:base, "player account already exist")
    error_response('Player account already exist', @user.errors.full_messages, :bad_request) if @user.player
  end
end
