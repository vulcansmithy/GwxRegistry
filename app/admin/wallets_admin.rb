Trestle.resource(:wallets) do
  menu do
    group :admin do
      item :wallets, icon: 'fa fa-google-wallet', priority: :last
    end
  end

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

  form do
    text_field :wallet_address
    text_field :pk, label: 'PK'
    hidden_field :account_type, value: 'User'
    select :account_id, User.all
    if params[:action] == 'show'
      row do
        col(xs: 6) { datetime_field :updated_at, disabled: true }
        col(xs: 6) { datetime_field :created_at, disabled: true }
      end
    end
  end
end
