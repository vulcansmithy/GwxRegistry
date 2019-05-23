class Api::V1::PlayerProfilesController < Api::V1::BaseController
  skip_before_action :doorkeeper_authorize!
  before_action :transform_params, only: %i[create update]
  before_action :set_player_profile, except: %i[index create]

  def index
    @player_profiles = @current_user.player_profiles.paginate(page: params[:page])
    success_response(PlayerProfileSerializer.new(@player_profiles).serialized_json)
  end

  def show
    success_response PlayerProfileSerializer.new(@player_profile).serialized_json
  end

  def create
    @game = Game.find(params[:game_id])
    @player_profile = @current_user.player_profiles.new(profile_params.merge(game_id: @game.id))

    if @player_profile.save
      success_response PlayerProfileSerializer.new(@player_profile).serialized_json, :created
    else
      error_response 'Unable to create player account',
                     @player_profile.errors.full_messages, :unprocessable_entity
    end
  end

  def update
    if @player_profile.update(profile_params)
      success_response PlayerProfileSerializer.new(@player_profile).serialized_json
    else
      error_response 'Unable to update player profile',
                     @player_profile.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def destroy
    if @player_profile.destroy
      render status: :no_content
    else
      error_response 'Unable to delete player profile',
                     @player_profile.errors.full_messages,
                     :unprocessable_entity
    end
  end

  def triggers
    @triggers = @player_profile.triggers.paginate(page: params[:page])
    success_response TriggerSerializer.new(@triggers).serialized_json
  end

  private

  def profile_params
    params.permit(:username, :game_id)
  end

  def set_player_profile
    @player_profile = @current_user.player_profiles.find params[:id]
  end
end
