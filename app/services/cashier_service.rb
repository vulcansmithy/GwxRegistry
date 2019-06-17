class CashierService
  class InvalidArgumentError < StandardError; end

  def initialize
    @base_url = Rails.application.secrets.cashier_url
  end

  def create_transaction(args)
    validate_args(args)

    body = {
      source_wallet_address: args[:source_wallet],
      destination_wallet_address: args[:destination_wallet],
      quantity: args[:quantity]
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

  def validate_args(args)
    if args.keys.map(&:to_sym).sort != required_args
      raise InvalidArgumentError, 'Invalid argument error.'
    end
  end

  def required_args
    [:source_wallet, :destination_wallet, :quantity].sort
  end
end
