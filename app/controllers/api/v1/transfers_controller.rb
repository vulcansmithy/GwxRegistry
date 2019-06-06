class Api::V1::TransfersController < Api::V1::BaseController
  skip_before_action :authenticate_request

  def create
    response = CashierService.new.create_transaction transfer_params
    success_response response
  end

  def show
    response = CashierService.new.find_transaction params[:id]
    success_response response
  end

  private
  
  def transfer_params
    params.permit(:source_wallet, :destination_wallet, :quantity)
  end
end
