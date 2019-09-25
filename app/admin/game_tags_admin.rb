Trestle.resource(:game_tags) do
  controller do
    def create
      game = Game.find params[:game_tag][:game_id]
      tag = Tag.find params[:game_tag][:tag_id]

      game.tags << tag
      redirect_to edit_games_admin_path(id: params[:game_tag][:game_id])
    end
  end

  form do
    select :game_id, [Game.find(params[:game_id])]
    select :tag_id, Tag.all
  end

end
