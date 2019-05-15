class Api::V1::PlayerProfilesController < Api::V1::BaseController
  before_action :transform_params, only: :create

  def index
    @player_profiles = PlayerProfile.all
    success_response(PlayerProfileSerializer.new(@player_profiles).serialized_json)
  end

  def show
    @player_profile = PlayerProfile.find(params[:user_id])
    success_response(PlayerProfileSerializer.new(@player).serialized_json)
  end

  def my_player_profile
    success_response(PlayerProfileSerializer.new(@current_user.player_profile).serialized_json)
  end

  def create
    @player_profile = @current_user.player_profiles.create(player_profile_params)

    if @player_profile.save
      success_response(PlayerProfileSerializer.new(@player_profile).serialized_json, :created)
    else
      error_response("Unable to create player account",
                     @player_profile.errors.full_messages, :unprocessable_entity)
    end
  end

  def update
    if @player_profile.update(player_profile_params)
      success_response(PlayerProfileSerializer.new(@player_profile).serialized_json)
    else
      error_response("Unable to update player profile",
                     @player_profile.errors.full_messages, :unprocessable_entity)
    end
  end

  private

  def player_profile_params
    params.permit(:user_id, username)
  end

  def set_player_profile
    @player_profile = @current_user.player_profile
    unless @player_profile
      error_response("You don't have an existing player profile",
                     "Player profile does not exist", :not_found)
    end
  end
end
