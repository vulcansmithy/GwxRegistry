Trestle.resource(:users) do
  menu do
    group :admin do
      item :users, icon: 'fa fa-users', priority: :first
    end
  end

  search do |query|
    if query
      User.where('first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
    else
      collection
    end
  end

  table do
    column :first_name
    column :last_name
    column :email
    column :username
    column :created_at, align: :center
    actions
  end

  form do |user|
    tab :user do
      row do
        col(xs: 6) { text_field :first_name }
        col(xs: 6) { text_field :last_name }
      end
      text_field :email, disabled: params[:action] == 'show'
      text_field :username
      if params[:action] == 'new'
        password_field :password
        password_field :password_confirmation
      end
      if params[:action] == 'show'
        row do
          text_field :wallet_address, value: user.wallet&.wallet_address, disabled: true
          col(xs: 6) { datetime_field :updated_at, disabled: true }
          col(xs: 6) { datetime_field :created_at, disabled: true }
        end
      end
    end

    tab :games, badge: user.player_profiles.size do
      table user.player_profiles, admin: :player_profiles do
        column :game do |player|
          if player.game.present?
            link_to player.game.name, edit_games_admin_path(id: player.game.id)
          end
        end
        column :user do |player|
          "#{player&.user&.first_name} #{player&.user&.last_name}"
        end

        actions
      end

      concat admin_link_to('New Player', admin: :player_profiles, action: :new, params: { user_id: user }, class: "btn btn-success")
    end

    tab :game_wallets, badge: user.player_profiles.size do
      table user.player_profiles, admin: :player_profiles do
        column :wallet_address do |player|
          player.wallet.wallet_address
        end
        column :game do |player|
          player.game.name
        end
        column :balance do |player|
          balance = NemService.check_balance(player.wallet.wallet_address)
          "#{balance[:gwx].round(6) || 0} GWX"
        end
      end
    end

    wallet_transactions = if user.wallet&.wallet_address
                            NemService.wallet_transactions_for(user.wallet&.wallet_address)
                          else
                            []
                          end
    tab :transactions, badge: wallet_transactions.count do
      table wallet_transactions do
        column :recipient, header: 'Address', class: 'recipient' do |transaction|
          sender = Nem::Unit::Address.from_public_key(transaction.signer)
          is_sender = sender == user.wallet.wallet_address
          displayed_address = is_sender ? transaction.recipient : sender

          content_tag(:strong, displayed_address, class: "#{is_sender ? 'red' : 'green'}")
        end

        column :hash, class: 'hash' do |transaction|
          hash = truncate(transaction.hash, length: 100)
          nembex_link = Rails.env.production? ? 'http://chain.nem.ninja/#/transfer' : "http://bob.nem.ninja:8765/#/transfer"
          link_to hash, "#{nembex_link}/#{hash}", target: "_blank"
        end

        column :amount do |transaction|
          amount = transaction.mosaics.find { |m| m.name == 'gwx' }.quantity / 1_000_000
          "#{amount.round(6)} GWX"
        end
      end
    end
  end

end
