Trestle.resource(:users) do
  menu do
    item :users, icon: "fa fa-users"
  end
  search do |query|
    if query
      User.where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?", "%#{query}%", "%#{query}%", "%#{query}%")
    else
      User.all
    end
  end

  
  table do
    column :first_name
    column :last_name
    column :email
    column :created_at, align: :center
    actions
  end

  form do |user|
    row do
      col(xs: 6) { text_field :first_name }
      col(xs: 6) { text_field :last_name }
    end
    text_field :email
    if params[:action] === 'new'
      password_field :password
      password_field :password_confirmation
      row do
        col(xs: 6) { datetime_field :updated_at }
        col(xs: 6) { datetime_field :created_at }
      end
    end
  end
end
