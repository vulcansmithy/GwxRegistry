class Api::V2::WalletsController < Api::V2::BaseController
  def show
    @wallet = Wallet.find_by(wallet_address: params[:wallet_address])
    if @wallet
      success_response(WalletSerializer.new(@wallet).serialized_json)
    else
      error_response('', 'Wallet address not found', :not_found)
    end
  end

  def balance
    @bal = NemService.check_balance(params[:wallet_address])
    success_response(balance: @bal)
  end
end
