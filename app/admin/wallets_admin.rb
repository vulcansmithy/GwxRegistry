Trestle.resource(:wallets) do
  table do
    column :id
    column :wallet_address, align: :center
    column :type, ->(wallet) { wallet.account_type }
    column :account do |wallet|
      if wallet.account.nil?
        nil
      else
        account = wallet.account
        case wallet.account_type
        when 'Game'
          account.name || ''
        when 'User'
          "#{account.first_name || ''} #{account.last_name || ''}"
        when 'Publisher'
          account.publisher_name || ''
        end
      end
    end

    actions
  end

  return_to on: :create do |wallet|
    users_admin_path(id: wallet.account_id)
  end

  form do
    account = NemService.create_account
    text_field :wallet_address, value: account[:address]
    hidden_field :pk, label: 'PK', value: account[:priv_key]
    hidden_field :account_type, value: 'User'
    if params[:user_id]
      user = User.find params[:user_id]
      select :account_id, [["#{user.first_name}" "#{user.last_name}", user.id]]
    else
      select :account_id, User.all
    end
    if params[:action] == 'show'
      row do
        col(xs: 6) { datetime_field :updated_at, disabled: true }
        col(xs: 6) { datetime_field :created_at, disabled: true }
      end
    end
  end
end
