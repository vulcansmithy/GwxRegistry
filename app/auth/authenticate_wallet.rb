class AuthenticateWallet
  prepend SimpleCommand
  attr_accessor :wallet_address, :result, :success, :errors

  def initialize(wallet_address)
    @wallet_address = wallet_address
    @result = nil
    @success = false
    @errors = nil
  end

  def call
    auth_user = wallet_user
    @result = {
      token: JsonWebToken.encode(user_id: auth_user.id),
      user: UserSerializer.new(auth_user).serializable_hash
    }
  end

  private

  def wallet_user
    user = Wallet.find_by(wallet_address: @wallet_address, account_type: "User")&.account
    if user
      @success = true
      return user
    end
    @errors = 'Invalid credentials'
    nil
  end
end
