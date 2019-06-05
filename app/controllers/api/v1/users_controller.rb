class Api::V1::UsersController < Api::V1::BaseController
  # before_action :doorkeeper_authorize!, except: %i[create login confirm update show forgot]
  # skip_before_action :doorkeeper_authorize!
  skip_before_action :authenticate_request

  def index
    @users = User.all.paginate(page: params[:page])
    serialized_users = PublicUserSerializer.new(@users).serializable_hash
    success_response paginate_result(serialized_users, @users)
  end

  def show
    @user = User.find params[:id]
    success_response(PublicUserSerializer.new(@user).serialized_json)
  end
end
