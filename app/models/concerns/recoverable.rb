module Recoverable
  extend ActiveSupport::Concern

  def reset_password!
    temp_password = generate_temporary_password

    update password: temp_password,
           password_confirmation: temp_password,
           temporary_password: temp_password

    send_temporary_password
  end

  def update_password(params)
    update temporary_password: nil,
           reset_password_sent_at: nil,
           password: params[:password],
           password_confirmation: params[:password_confirmation]
  end

  def send_temporary_password
    UserMailer.reset_password(self).deliver_later(wait: 1.second)
    update(reset_password_sent_at: Time.now.utc)
  end

  private

  def generate_temporary_password
    SecureRandom.alphanumeric(8)
  end
end