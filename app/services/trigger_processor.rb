class TriggerProcessor
  attr_reader :source_wallet,
              :destination_wallet,
              :quantity,
              :trigger,
              :base_url

  def initialize(trigger, args = nil)
    @trigger = trigger
    @quantity = args[:quantity]
    @base_url = ENV['CASHIER_URL']
  end

  def process
    @source_wallet = player_profile.wallet.wallet_address
    @destination_wallet = action.game.wallet.wallet_address
    @quantity = action.fixed ? action.fixed_amount : @quantity

    body = {
      source_wallet_address: @source_wallet,
      destination_wallet_address: @destination_wallet,
      quantity: @quantity
    }.to_json

    response = HTTParty.post(@base_url,
      body: body,
      headers: {
        'Content-Type': 'application/json'
      }
    )
  end

  private

  def action
    @action ||= @trigger.action
  end

  def player_profile
    @player_profile ||= @trigger.player_profile
  end
end