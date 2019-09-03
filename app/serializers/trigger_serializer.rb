class TriggerSerializer
  include FastJsonapi::ObjectSerializer

  set_key_transform :camel_lower

  attributes :id,
             :action_id,
             :player_profile_id,
             :created_at

  attribute :transaction_details do |trigger|
    if trigger.transaction_id.present?
      res = CashierService.new.find_transaction(trigger.transaction_id)
      {
        transactionHash: res["data"]["attributes"]["txHash"],
        status: res["data"]["attributes"]["status"],
        quantity: res["data"]["attributes"]["quantity"],
        details: res["data"]["attributes"]["transaction_details"]
      }
    end
  end

  belongs_to :action
  belongs_to :player_profile
end
