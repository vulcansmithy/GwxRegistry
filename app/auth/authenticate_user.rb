class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password, :result, :success, :errors

  def initialize(email, password)
    @email = email
    @password = password
    @result = nil
    @success = false
    @errors = nil
  end

  def call
    auth_user = user
    user.update(last_login: Time.now)

    @result = {
      token: JsonWebToken.encode(user_id: auth_user.id),
      user: UserSerializer.new(auth_user).serializable_hash
    }
  end

  private

  def user
    user = User.find_by_email(email)
    if user && user.authenticate(password)
      @success = true
      return user
    end
    @errors = 'Invalid credentials'
    nil
  end
end
