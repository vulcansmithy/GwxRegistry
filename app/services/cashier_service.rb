class CashierService
  class InvalidArgumentError < StandardError; end

  def initialize
    @base_url = ENV['CASHIER_URL']
  end

  def create_transaction(args)
    validate_args(args)

    body = {
      source_wallet_address: source_wallet(args),
      destination_wallet_address: destination_wallet(args),
      quantity: args[:quantity],
      message: args[:message],
      dw_transaction_id: args[:dw_transaction_id]
    }.to_json

    response = HTTParty.post(@base_url,
      body: body,
      headers: {
        'Content-Type': 'application/json'
      }
    )
  end

  def find_transaction(id)
    HTTParty.get("#{@base_url}/#{id}")
  end

  private

  def source_wallet(args)
    if args[:source_user_id]
      find_wallet_address args[:source_user_id]
    else
      args[:source_wallet]
    end
  end

  def destination_wallet(args)
    if args[:destination_user_id]
      find_wallet_address args[:destination_user_id]
    else
      args[:destination_wallet]
    end
  end

  def find_wallet_address(id)
    wallet = Wallet.find_by!(
      account_id: id,
      account_type: 'User'
    )
    wallet.wallet_address
  end

  def validate_args(args)
    args_union = args.keys.map(&:to_sym) | required_args
    if args_union.sort != required_args
      raise InvalidArgumentError, 'Invalid argument error.'
    end
  end

  def required_args
    [
      :source_user_id,
      :destination_user_id,
      :source_wallet,
      :destination_wallet,
      :quantity,
      :message,
      :dw_transaction_id
    ].sort
  end
end
