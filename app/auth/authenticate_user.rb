class AuthenticateUser
  prepend SimpleCommand
  attr_accessor :email, :password, :result, :success, :errors

  #this is where parameters are taken when the command is called
  def initialize(email, password)
    @email = email
    @password = password
    @result = nil
    @success = false
    @errors = nil
  end
  
  #this is where the result gets returned
  def call
    auth_user = user
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
