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
    auth_user = wallet
    @result = {
      token: JsonWebToken.encode(wallet_address: auth_wallet.wallet_address),
      wallet: WalletSerializer.new(auth_wallet).serializable_hash
    }
  end

  private

  def wallet
    wallet = Wallet.find_by(wallet_address: params[:wallet_address], account_type: "User").account
    if wallet
      @success = true
      return user
    end
    @errors = 'Invalid credentials'
    nil
  end
end
