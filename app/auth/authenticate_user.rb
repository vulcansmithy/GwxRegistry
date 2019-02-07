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
    @result = JsonWebToken.encode(user_id: user.id) if user
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
