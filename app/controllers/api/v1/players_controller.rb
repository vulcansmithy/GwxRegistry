class Api::V1::PlayersController < Api::V1::BaseController
  # @TODO temporary disable authentication
=begin  
  skip_before_action :authenticate_request, only: [:edit, :create, :update, :find_user, :show]
=end
  
  before_action :initialization, only: [:create]
  before_action :find_user, only: [:create, :show, :edit, :update]

  def index
    @players = Player.all
    render json: { players: @players }
  end

  def show
    render json: { player: @user.player }
  end

  def create
    @player = @user.create_player(player_params)
    @player.wallet_address = @account.address

    if @player.save
      message = 'Player account successfully created'
    else
      message = @user.errors.full_messages
    end
    render json: { message: message, account: @account }
  end

  def edit
    @player = @user.player
  end

  def update
    @player = @user.player
    if @player.update(player_params)
      message = 'Player account successfully updated'
    else
      message = @player.errors.full_message
    end
    render json: {message: message}
  end

  private

  def initialization
    @nem = NemService.new
    @account = @nem.generate_account
  end

  def player_params
    params.require(:player).permit(:username, :user_id, :wallet_address)
  end

  def find_user
    @user = User.find(params[:player][:user_id])
  end
end
