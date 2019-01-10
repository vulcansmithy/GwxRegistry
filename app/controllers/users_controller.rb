class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: %i[login register]

  def register
    @user = User.create(user_params)
    if @user.save
      response = { message: 'User created successfully' }
      render json: response, status: :created 
   else
    render json: @user.errors, status: :bad
   end 
  end

  private

  def user_params
    params.permit(
      :first_name,
      :last_name,
      :email,
      :password,
      :password_confirmation
    )
  end
end
