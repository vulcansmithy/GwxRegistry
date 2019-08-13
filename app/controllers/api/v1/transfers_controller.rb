class Api::V1::TransfersController < Api::V1::BaseController
  skip_before_action :authenticate_request

  before_action :set_game_wallet_address, only: :seamless_transfer
  before_action :set_user_wallet_address, only: :seamless_transfer

  def create
    response = CashierService.new.create_transaction transfer_params
    success_response response
  end

  def show
    response = CashierService.new.find_transaction params[:id]
    success_response response
  end

  def seamless_transfer
    raise ExceptionHandler::InvalidArgs, 'Invalid arguments' unless valid_params?

    source_wlt = params[:type] == 'debit' ? @user_wallet_address : @game_wallet_address
    destination_wlt = params[:type] == 'debit' ? @game_wallet_address : @user_wallet_address
    balance = NemService.check_balance(source_wlt)

    if balance[:xem] >= 1.25 && (balance[:gwx] || 0) > seamless_params[:quantity].to_f
      response = CashierService.new.create_transaction(
        source_wallet: source_wlt,
        destination_wallet: destination_wlt,
        quantity: seamless_params[:quantity].to_f
      )

      success_response(transaction: response, balance: balance)
    else
      error_response '', 'Insufficient balance', 422
    end
  end

  def balance
    player = PlayerProfile.find_by! username: params[:username]
    user_wallet = player.user.wallet.wallet_address
    balance = NemService.check_balance(user_wallet)

    if params[:game_id]
      game_wallet = Game.find(params[:game_id]).wallet.wallet_address

      unconfirmed_bets = NemService.unconfirmed_transactions(
        user_wallet,
        game_wallet,
        'gwx'
      )

      unconfirmed_rewards = NemService.unconfirmed_transactions(
        game_wallet,
        user_wallet,
        'gwx'
      )

      current_gwx_balance = (balance[:gwx] || 0) + unconfirmed_rewards - unconfirmed_bets
      available_gwx = balance[:gwx] || 0

      response = {
        unconfirmed_bets: unconfirmed_bets,
        unconfirmed_rewards: unconfirmed_rewards,
        current_gwx_balance: current_gwx_balance,
        available_gwx: available_gwx
      }.merge(balance)

      success_response(balance: response)
    else
      success_response(balance)
    end
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
      :quantity
    )
  end

  def set_user_wallet_address
    player = PlayerProfile.find_by! username: seamless_params[:username],
                                   game_id: seamless_params[:game_id]

    @user_wallet_address = player.user.wallet.wallet_address
  end

  def set_game_wallet_address
    game = Game.find seamless_params[:game_id]
    @game_wallet_address = game.wallet.wallet_address
  end

  def valid_params?
    ['debit', 'credit'].include? params[:type]
  end
end
