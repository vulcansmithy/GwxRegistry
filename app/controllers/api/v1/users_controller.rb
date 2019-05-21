class Api::V1::UsersController < Api::V1::BaseController
  # before_action :doorkeeper_authorize!, except: %i[create login confirm update show forgot]
  skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_request

  def index
    @users = User.all
    success_response(UserSerializer.new(@users).serialized_json)
  end

  def show
    @user = User.find params[:id]
    success_response(UserSerializer.new(@user).serialized_json)
  end
end
