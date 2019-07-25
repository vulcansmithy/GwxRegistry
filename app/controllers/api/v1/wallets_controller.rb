class Api::V1::WalletsController < Api::V1::BaseController
  skip_before_action :authenticate_request
  before_action :transform_params

  def show
    @wallet = Wallet.find_by(wallet_query_params)
    if @wallet
      success_response(WalletSerializer.new(@wallet).serialized_json)
    else
      error_response('', 'Wallet address not found', :not_found)
    end
  end

  def balance
    @bal = NemService.check_balance(params[:wallet_address])
    wallet = Wallet.find_by!(wallet_address: params[:wallet_address])

    if wallet.account_type == 'Player' && params[:game_wallet_address]
      player_wallet = wallet.wallet_address
      user_wallet = wallet.account.user.wallet.wallet_address
      game_wallet = params[:game_wallet_address]

      unconfirmed_bets = NemService.unconfirmed_transactions(
        player_wallet,
        game_wallet,
        'gwx'
      )

      unconfirmed_rewards = NemService.unconfirmed_transactions(
        game_wallet,
        player_wallet,
        'gwx'
      )

      unconfirmed_cashin = NemService.unconfirmed_transactions(
        user_wallet,
        player_wallet,
        'gwx'
      )

      current_gwx_balance = (@bal[:gwx] || 0) + unconfirmed_rewards + unconfirmed_cashin - unconfirmed_bets
      available_gwx = @bal[:gwx] || 0

      response = {
        unconfirmed_bets: unconfirmed_bets,
        unconfirmed_rewards: unconfirmed_rewards,
        unconfirmed_cashin: unconfirmed_cashin,
        current_gwx_balance: current_gwx_balance,
        available_gwx: available_gwx
      }.merge(@bal)

      success_response({ balance: response })
    else
      success_response({ balance: @bal })
    end
  end

  def account
    @wallet = Wallet.find_by!(wallet_address: params[:wallet_address])
    if @wallet&.account_type == "PlayerProfile"
      success_response PlayerProfileSerializer.new(@wallet.account).serialized_json
    else
      error_response("", "Account not found", :unprocessable_entity)
    end
  end

  private

  def wallet_query_params
    if params[:account_type]
      {
        account_id: params[:wallet_address],
        account_type: params[:account_type].capitalize
      }
    else
      { wallet_address: params[:wallet_address] }
    end
  end
end
