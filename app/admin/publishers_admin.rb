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
    column :wallet_address, class: 'recipient' do |instance|
      instance.wallet.wallet_address
    end
    column :balance do |instance|
      balance = NemService.check_balance(instance.wallet.wallet_address)
      "#{balance[:gwx] || 0} GWX, #{balance[:xem] } XEM"
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
        column :tags, format: :tags, class: 'hidden-xs' do |game|
          game.tags.map(&:name)
        end

        actions
      end

      concat admin_link_to('New Game', admin: :games, action: :new, params: { publisher_id: publisher}, class: 'btn btn-success')
    end

    wallet_transactions = publisher.games.map do |game|
      NemService.wallet_transactions_for(game.wallet.wallet_address)
    end

    wallet_transactions = wallet_transactions.flatten.sort_by { |t| t.timestamp.to_time }.reverse

    tab :transactions, badge: wallet_transactions.count do
      table wallet_transactions do
        column :recipient, header: 'Address', class: 'recipient' do |transaction|
          sender = Nem::Unit::Address.from_public_key(transaction.signer)

          safe_join([
            content_tag(:span, "From: #{sender}"),
            content_tag(:span, "To: #{transaction.recipient}")
          ], '<br />'.html_safe)
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
