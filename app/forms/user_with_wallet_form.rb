class UserWithWalletForm
  
  include ActiveModel::Model
  include WalletPkSecurity::Splitter

  attr_accessor(
    :success,
    :first_name,
    :last_name,
    :email,
    :password,
    :password_confirmation,
    :user
  )

  validates :email, presence: true
  validates :password, presence: true

  def initialize(attributes = {})
    super
  end

  def save
    ActiveRecord::Base.transaction do
      begin
        if valid?
          account = NemService.create_account
          @user   = create_user
          if ENV["SHARDING_ENABLED"].present? && ENV["SHARDING_ENABLED"].downcase.to_sym == :on
            result  = split_up_and_distribute(account[:address], account[:priv_key])
            @user.create_wallet(
              wallet_address: account[:address],
              custodian_key: result[:shards][0]
            )
          else
            @user.create_wallet(
              wallet_address: account[:address],
              pk: account[:priv_key]
            )
          end    
          @success = true
        else
          @success = false
        end
      rescue => e
        self.errors.add(:base, e.message)
        @success = false
      end
    end
  end

  def create_user
    User.create!(
      first_name: @first_name,
      last_name: @last_name,
      email: @email,
      password: @password,
      password_confirmation: @password_confirmation,
      avatar: @avatar
    )
  end
end
