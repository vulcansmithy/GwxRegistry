class UserMailer < ApplicationMailer
  default from: 'Gameworks Registry Team <no-reply@gameworks.io>'

  def account_confirmation(user)
    @user = user
    mail(to: @user.email,
         subject: 'Gameworks Registry')
  end
end