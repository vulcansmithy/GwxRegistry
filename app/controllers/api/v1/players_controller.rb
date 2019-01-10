class Api::V1::PlayersController < Api::V1::BaseController
  before_action :initialize
  before_action :find_user

  def create
    @player = @user.create_player(player_params)
    account = @nem.generate_account
    render json: {message: account}
    if @player.save
      message = 'Player account successfully created'
    else
      message = @user.errors.full_messages
    end
    render json: {message: message}
  end

  def show
    render json: {user: @user.player}
  end

  private

  def initialize
    @nem = NemService.new
  end

  def player_params
    params.require(:player).permit(:username, :user_id, :wallet_address)
  end

  def find_user
    @user = User.find(params[:player][:user_id])
  end
end
