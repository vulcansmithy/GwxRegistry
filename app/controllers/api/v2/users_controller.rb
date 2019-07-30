class Api::V2::UsersController < Api::V2::BaseController
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
