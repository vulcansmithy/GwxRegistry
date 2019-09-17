Trestle.resource(:player_profiles) do
  menu do
    group :admin do
      item :player_profiles, icon: 'fa fa-list-ul', priority: 4
    end
  end

  return_to on: :create do |player_profile|
    referrer = request.referrer
    query = URI.parse(referrer).query

    if query.nil?
      edit_player_profiles_admin_path(id: player_profile.id)
    else
      prev_params = CGI.parse(URI.parse(referrer).query)

      if prev_params['user_id'].first.present?
        edit_users_admin_path(id: prev_params['user_id'].first)
      elsif prev_params['game_id'].first.present?
        edit_games_admin_path(id: prev_params['game_id'].first)
      else
        edit_player_profiles_admin_path(id: player_profile.id)
      end
    end
  end

  build_instance do |attrs, params|
    scope = if params[:user_id]
              User.find(params[:user_id]).player_profiles
            elsif params[:game_id]
              Game.find(params[:game_id]).player_profiles
            else
              PlayerProfile
            end

    scope.new(attrs)
  end

  table do
    column :id
    column :user
    column :game
    column :username, ->(player_profile) { player_profile.user.username }
    column :created_at, align: :center
  end

  form do
    select :user_id, User.all
    select :game_id, Game.all
    if params[:action] == 'show'
      row do
        col(xs: 6) { datetime_field :updated_at, disabled: true }
        col(xs: 6) { datetime_field :created_at, disabled: true }
      end
    end
  end
end
