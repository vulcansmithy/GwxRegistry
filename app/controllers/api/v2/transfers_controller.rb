class Api::V2::TransfersController < Api::V2::BaseController
  skip_before_action :authenticate_request

  before_action :set_game, only: :seamless_transfer
  before_action :set_user_wallet_address, only: :seamless_transfer

  def create
    response = CashierService.new.create_transaction transfer_params
    if response.code == 200
      success_response response
    else
      error_response response['message'], nil, response.code
    end
  end

  def show
    response = CashierService.new.find_transaction params[:id]
    success_response response
  end

  def seamless_transfer
    raise ExceptionHandler::InvalidArgs, 'Invalid arguments' unless valid_params?

    source_wlt = params[:type] == 'debit' ? @user_wallet_address : @game.wallet.wallet_address
    destination_wlt = params[:type] == 'debit' ? @game.wallet.wallet_address : @user_wallet_address
    balance = NemService.check_game_balance(
      wallet_address: @user_wallet_address,
      game_address: @game.wallet.wallet_address
    )

    if balance[:xem] >= 0.1 && (balance[:gwx] || 0) > seamless_params[:quantity].to_f
      response = CashierService.new.create_transaction(
        source_wallet: source_wlt,
        destination_wallet: destination_wlt,
        quantity: seamless_params[:quantity].to_f,
        message: "#{@game.publisher_id}, #{seamless_params[:message]}"
      )

      success_response(transaction: response, balance: balance)
    else
      error_response '', 'Insufficient balance', 422
    end
  end

  def balance
    user = User.find params[:username]
    balance = NemService.check_balance(user.wallet.wallet_address)
    success_response(balance)
  end

  private

  def seamless_params
    params.permit(:game_id, :username, :quantity, :type)
  end

  def transfer_params
    params.permit(
      :source_user_id,
      :destination_user_id,
      :source_wallet,
      :destination_wallet,
      :quantity,
      :message
    )
  end

  def set_user_wallet_address
    user = User.find seamless_params[:username]
    @user_wallet_address = user.wallet.wallet_address
  end

  def set_game
    @game = Game.find seamless_params[:game_id]
  end

  def valid_params?
    %w[debit credit].include? params[:type]
  end
end
