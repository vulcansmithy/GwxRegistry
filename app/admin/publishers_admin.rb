Trestle.resource(:publishers) do
  menu do
    group :admin do
      item :publishers, icon: "fa fa-book", priority: 1
    end
  end

  search do |query|
    if query
      collection.where('publisher_name ILIKE ? OR description ILIKE ?', "%#{query}%", "%#{query}%")
    else
      collection
    end
  end

  table do
    column :publisher_name
    column :description
    column :wallet_address do |instance|
      instance.wallet.wallet_address
    end
    column :created_at, align: :center
    actions
  end

  form do |publisher|
    tab :publisher do
      text_field :publisher_name
      text_field :description
      if params[:action] == 'show'
        text_field :wallet_address, value: publisher.wallet&.wallet_address, disabled: true
        row do
          col(xs: 6) { datetime_field :updated_at, disabled: true }
          col(xs: 6) { datetime_field :created_at, disabled: true }
        end
      end
    end

    tab :games, badge: publisher.games.size do
      table publisher.games, admin: :games do
        column :icon, header: nil, align: :center, class: "poster-column" do |game|
          admin_link_to(image_tag(game.icon.url, class: "poster", style: "width: 50px"), game) if game.icon?
        end
        column :name
        column :description
        column :tags, format: :tags, class: 'hidden-xs' do |game|
          game.tags.map(&:name)
        end

        actions
      end

      concat admin_link_to('New Game', admin: :games, action: :new, params: { publisher_id: publisher}, class: 'btn btn-success')
    end
  end
end
