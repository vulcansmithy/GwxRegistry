Trestle.admin(:dashboard) do
  menu do
    group :admin do
      item :dashboard, icon: "fa fa-tachometer", priority: :first
    end
  end

  controller do
    def index
      @game_count = Game.all.count
      @user_count = User.all.count
      @publisher_count = Publisher.all.count
      @wallet_count = Wallet.all.count
    end
  end
end
