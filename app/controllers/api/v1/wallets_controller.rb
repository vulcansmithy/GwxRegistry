class Api::V1::WalletsController < Api::V1::BaseController
  skip_before_action :authenticate_request, only: :show

  def show
    @wallet = Wallet.find_by(wallet_address: params[:wallet_address])
    success_response(WalletSerializer.new(@wallet).serialized_json)
  end

  def balance
    @bal = NemService.check_balance(params[:wallet_address])
    success_response({balance: @bal})
  end
end
