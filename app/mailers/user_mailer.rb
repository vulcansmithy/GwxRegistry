class UserMailer < ApplicationMailer
  default from: 'no-reply@gameworks.io'

  def account_confirmation(user)
    @user = user
    mail(to: @user.email,
         subject: 'Gameworks Registry')
  end

  def reset_password(user)
    @user = user
    mail(to: @user.email,
         subject: 'Gameworks Registry')
  end
end
