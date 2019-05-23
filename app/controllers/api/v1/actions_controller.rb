class Api::V1::ActionsController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  before_action :transform_params
  before_action :set_publisher
  before_action :set_game, except: :triggers
  before_action :set_action, only: %i[show update destroy]

  def index
    @actions = @game.actions.paginate(page: params[:page])
    success_response ActionSerializer.new(@actions).serialized_json
  end

  def show
    success_response ActionSerializer.new(@action).serialized_json
  end

  def create
    @action = @game.actions.new action_params
    if @action.save
      success_response ActionSerializer.new(@action).serialized_json, :created
    else
      error_response "Unable to create action",
                     @action.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def update
    if @action.update action_params
      success_response ActionSerializer.new(@action).serialized_json
    else
      error_response "Unable to update action",
                     @action.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def destroy
    if @action.destroy
      render status: :no_content
    else
      error_response "Unable to create action",
                     @action.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def triggers
    @action = Action.find params[:id]
    @triggers = @action.triggers.paginate(page: params[:page])
    success_response TriggerSerializer.new(@triggers).serialized_json
  end

  private

  def action_params
    params.permit(
      :game_id,
      :name,
      :description,
      :fixed_amount,
      :unit_fee,
      :fixed,
      :rate
    )
  end

  def set_publisher
    @publisher = @current_user.publisher
    unless @publisher
      error_response("", "Publisher account does not exist", :unauthorized)
    end
  end

  def set_game
    @game = @publisher.games.find params[:game_id]
  end

  def set_action
    @action = @game.actions.find params[:id]
  end
end
