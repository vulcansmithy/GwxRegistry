Trestle.resource(:games) do
  menu do
    group :admin do
      item :games, icon: 'fa fa-gamepad', priority: 2
    end
  end

  search do |query|
    if query
      collection.where('name ILIKE ? OR description ILIKE ?', "%#{query}%", "%#{query}%")
    else
      collection
    end
  end

  return_to on: :create do |game|
    referrer = request.referrer
    query = URI.parse(referrer).query

    if query.nil?
      edit_games_admin_path(id: game.id)
    else
      prev_params = CGI.parse(query)

      if prev_params['publisher_id'].first.present?
        edit_publishers_admin_path(id: prev_params['publisher_id'].first)
      else
        edit_games_admin_path(id: game.id)
      end
    end
  end

  collection do
    model.includes(:tags)
  end

  controller do
    def create
      params[:game]["blacklisted_countries"].shift
      super
    end

    def update
      params[:game]["blacklisted_countries"].shift
      super
    end
  end

  table do
    column :icon, header: nil, align: :center, class: "poster-column" do |game|
      admin_link_to(image_tag(game.icon.url, class: "poster", style: "width: 50px"), game) if game.icon?
    end
    column :name, class: 'game-name' do |game|
      safe_join([
        content_tag(:strong, game.name),
        content_tag(:a, game.publisher.publisher_name, href: edit_publishers_admin_path(id: game.publisher.id))
      ], '<br />'.html_safe)
    end
    column :wallet_address, class: 'recipient' do |game|
      balance = NemService.check_balance(game.wallet.wallet_address)

      safe_join([
        content_tag(:strong, game.wallet.wallet_address, class: 'recipient'),
        content_tag(:span, "Balance: #{balance[:gwx]&.round(6) || 0} GWX, #{balance[:xem]} XEM")
      ], '<br />'.html_safe)
    end
    column :tags, format: :tags, class: 'hidden-xs' do |game|
      game.tags.map(&:name)
    end
    column :blacklisted_countries do |game|
      game.blacklisted_countries.join(', ') if game.blacklisted_countries.present?
    end
    column :created_at, align: :center
    actions
  end

  form do |game|
    tab :game do
      number_field :id, label: 'ID (Optional)'
      text_field :name, required: true
      text_field :description, required: true
      form_group :icon, label: false do
        link_to image_tag(game.icon.url, style: "120px"), game.icon.url, data: { behavior: "zoom" } if game.icon?
      end
      file_field :icon, required: game.icon.url.nil?, value: game.icon.url
      form_group :cover, label: false do
        link_to image_tag(game.cover.url, style: "120px"), game.cover.url, data: { behavior: "zoom" } if game.cover?
      end
      file_field :cover, value: game.cover
      check_box :featured
      select :blacklisted_countries, options_for_select(ISO3166::Country.all.map(&:name), game.blacklisted_countries), {}, multiple: true
      
      if params[:action] == 'new' && params[:publisher_id].nil?
        select :publisher_id, (Publisher.all.map { |p| [p.publisher_name, p.id]})
      elsif params[:action] == 'new' && params[:publisher_id].present?
        publisher = Publisher.find(params[:publisher_id])
        select :publisher_id, [[publisher.publisher_name, publisher.id]]
      elsif params[:action] == 'create'
        select :publisher_id, (Publisher.all.map { |p| [p.publisher_name, p.id]})
      end
      if params[:action] == 'show' || params[:action] == 'edit'
        text_field :wallet_address, value: game.wallet&.wallet_address, disabled: true
        select :publisher_id, (Publisher.all.map { |p| [p.publisher_name, p.id] })
        row do
          col(xs: 6) { datetime_field :updated_at, disabled: true }
          col(xs: 6) { datetime_field :created_at, disabled: true }
        end
      end
    end

    if params[:action] != 'new'
      tab :players, badge: game.player_profiles.size do
        table game.player_profiles, admin: :player_profiles do
          column :user do |player|
            link_to "#{player&.user&.first_name} #{player&.user&.last_name}", edit_users_admin_path(id: player&.user&.id)
          end
          column :username do |player|
            player.user.username
          end

          actions
        end

        concat admin_link_to('New Player', admin: :player_profiles, action: :new, params: { game_id: game }, class: "btn btn-success")
      end

      tab :tags, badge: game.tags.size do
        table game.tags, admin: :tags do
          column :id
          column :name

          actions
        end

        concat admin_link_to('New Tag', admin: :game_tags, action: :new, params: { game_id: game }, class: "btn btn-success")
      end

      
      if !game.wallet.nil? 
        wallet_transactions = NemService.wallet_transactions_for(game.wallet.wallet_address)
        tab :transactions, badge: wallet_transactions.count do
          table wallet_transactions do
            column :recipient, class: 'recipient' do |transaction|
              truncate(transaction.recipient, length: 60)
            end
            column :hash, class: 'hash' do |transaction|
              hash = truncate(transaction.hash, length: 100)
              nembex_link = Rails.env.production? ? 'http://chain.nem.ninja/#/transfer' : "http://bob.nem.ninja:8765/#/transfer"
              link_to hash, "#{nembex_link}/#{hash}", target: "_blank"
            end
            column :amount do |transaction|
              amount = transaction.mosaics.find { |m| m.name == 'gwx'}.quantity / 1_000_000
              "#{amount.round(6)} GWX"
            end
          end
        end
      end
    end
  end

end
