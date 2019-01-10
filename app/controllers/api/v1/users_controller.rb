class Api::V1::UsersController < Api::V1::BaseController
  def create
    @user = User.create(user_params)
    if @user.save
      message = 'User account successfully created'
    else
      message = @user.errors.full_messages
    end
    render json: {message: message}
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
                                 :wallet_address)
  end
end
