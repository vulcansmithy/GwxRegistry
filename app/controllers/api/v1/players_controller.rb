class Api::V1::PlayersController < Api::V1::BaseController
  # @TODO temporary disable authentication
=begin
  skip_before_action :authenticate_request, only: [:edit, :create, :update, :find_user, :show]
=end

  before_action :initialization, only: [:create]
  before_action :find_user, only: [:create, :show, :edit, :update]
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

  def show
    success_response(PlayerSerializer.new(@player).serialized_json)
  end

  def create
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

  def update
    if @player.update(player_params)
      success_response(PlayerSerializer.new(@player).serialized_json)
    else
      error_response('Unable to update player account',
                     @player.errors.full_messages, :bad_request)
    end
  end

  private

  def initialization
    @nem = NemService.new
  end

  def player_params
    params.require(:player).permit(:username, :user_id, :wallet_address)
  end

  def find_user
    @user = User.find(params[:player][:user_id])
  end

  def find_player
    @player = @user.player
  end

  def check_player
    @user.errors.add(:base, "player account already exist")
    error_response('Player account already exist', @user.errors.full_messages, :bad_request) if @user.player
  end
end
