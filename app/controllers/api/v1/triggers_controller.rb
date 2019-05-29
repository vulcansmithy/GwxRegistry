class Api::V1::TriggersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  before_action :transform_params

  def create
    @trigger = Trigger.new(trigger_params)

    if @trigger.save
      process_trigger(@trigger) unless Rails.env.test?
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
    TriggerProcessor.new(trigger, { quantity: params[:quantity] })
  end
end
