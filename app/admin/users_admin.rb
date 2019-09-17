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
      text_field :email
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

    tab :players, badge: user.player_profiles.size do
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
  end

end
