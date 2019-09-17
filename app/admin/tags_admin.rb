Trestle.resource(:tags) do
  menu do
    group :admin do
      item :tags, icon: 'fa fa-star', priority: 3
    end
  end

  return_to on: :create do |tag|
    referrer = request.referrer
    query = URI.parse(referrer).query

    if query.nil?
      edit_tags_admin_path(id: tag.id)
    else
      prev_params = CGI.parse(query)

      if prev_params['game_id'].first.present?
        edit_games_admin_path(id: prev_params['game_id'].first)
      else
        edit_tags_admin_path(id: tag.id)
      end
    end
  end

  build_instance do |attrs, params|
    scope = params['game_id'].present? ? Game.find(params['game_id']).tags : Tag
    scope.new(attrs)
  end
end
