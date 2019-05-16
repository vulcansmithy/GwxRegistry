class Api::V1::TriggersController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  before_action :transform_params

  def create
    @trigger = Trigger.new(trigger_params)

    if @trigger.save
      success_response(TriggerSerializer.new(@trigger).serialized_json,
                       :created)
    else
      error_response("Unable to create trigger",
                     @trigger.errors.full_messages, :unprocessable_entity)
    end
  end

  private
  def trigger_params
    params.permit(:game_id, :player_profile_id)
  end
end
