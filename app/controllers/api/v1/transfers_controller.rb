class Api::V1::TransfersController < Api::V1::BaseController
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
    raise ExceptionHandler::InvalidDWCredentials, 'Invalid credentials' unless valid_credentials?

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
        message: "#{@game.publisher_id}, #{seamless_params[:message]}",
        dw_transaction_id: seamless_params[:dw_transaction_id]
      )

      success_response(transaction: response, balance: balance)
    else
      error_response '', 'Insufficient balance', 422
    end
  end

  def balance
    user = User.find params[:user_id]
    user_wallet = user.wallet.wallet_address

    if params[:game_id]
      game_wallet = Game.find(params[:game_id]).wallet.wallet_address
      response = NemService.check_game_balance(
        game_address: game_wallet,
        wallet_address: user_wallet
      )

      success_response(balance: response)
    else
      balance = NemService.check_balance(user_wallet)

      success_response(balance)
    end
  end

  private

  def seamless_params
    params.permit(:game_id, :user_id, :quantity, :type, :message, :dw_transaction_id)
  end

  def transfer_params
    params.permit(
      :source_user_id,
      :destination_user_id,
      :source_wallet,
      :destination_wallet,
      :quantity,
      :message,
      :dw_transaction_id,
      :web_call_id,
      :web_call_key
    )
  end

  def set_user_wallet_address
    user = User.find seamless_params[:user_id]
    @user_wallet_address = user.wallet.wallet_address
  end

  def set_game
    @game = Game.find seamless_params[:game_id]
  end

  def valid_params?
    %w[debit credit].include? params[:type]
  end

  def valid_credentials?
    (ENV['DIGITAL_WIN_API_ID'] == transfer_params[:web_call_id]) && (ENV['DIGITAL_WIN_API_KEY'] == transfer_params[:web_call_key])
  end
end
