class Api::V1::TriggersController < Api::V1::BaseController
  before_action :transform_params

  def create
    @trigger = Trigger.new(trigger_params)

    if @trigger.save && process_trigger(@trigger)
      success_response TriggerSerializer.new(@trigger).serialized_json,
                       :created
    else
      error_response "Unable to create trigger",
                     @trigger.errors.full_messages,
                     :unprocessable_entity
    end
  end

  private

  def trigger_params
    params.permit(:action_id, :player_profile_id)
  end

  def process_trigger(trigger)
    return true if Rails.env.test?

    res = TriggerProcessor.new(trigger, { quantity: params[:quantity] }).process
    trigger.transaction_id = res["data"]["attributes"]["id"].to_i
    trigger.save
  end
end
