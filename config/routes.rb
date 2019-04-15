Rails.application.routes.draw do
  use_doorkeeper

  mount Rswag::Ui::Engine  => "/api-docs" if Rails.env.development? || Rails.env.staging?
  mount Rswag::Api::Engine => "/api-docs" if Rails.env.development? || Rails.env.staging?

  api_version(
    :module    => "Api::V1",
    :header    => { :name   => "Accept",  :value => "application/vnd.gameworks.io; version=1" },
    :parameter => { :name   => "version", :value => "1" },
    :path      => { :value  => "v1"   },
    :defaults  => { :format => "json" },
    :default   => true) do

    get  'public_key', to: 'services#public_key'
    get  'test',       to: 'users#test'
    post 'login',      to: 'users#login'
    post 'register',   to: 'users#create'
    get  'user',       to: 'users#show'
    post 'forgot',     to: 'users#forgot'
    post 'notify',     to: 'users#send_notification'
    get  'player',     to: 'players#my_player'
    get  'publisher',  to: 'publishers#show'

    resources :users, :except => [:destroy, :show] do
      collection do
        get '/confirm/:code',   to: 'users#confirm'
        get '/:id/resend_code', to: 'users#resend_code'
        get '/:wallet_address', to: 'users#find_player'
      end
    end

    resources :publishers, :except => [:show, :update, :destroy, :index] do
      collection do
        get   '/:user_id', to: 'publishers#show'
        patch '/:user_id', to: 'publishers#update'
        put   '/:user_id', to: 'publishers#update'
      end
    end

    resources :players, :except => [:show, :destroy] do
      collection do
        get   '/:user_id', to: 'players#show'
        patch '/:user_id', to: 'players#update'
        put   '/:user_id', to: 'players#update'
      end
    end

    resources :wallets, :except => [:show] do
      collection do
        get '/:wallet_address', to: 'wallets#show'
        get '/:wallet_address/balance', to: 'wallets#balance'
      end
    end
  end
  root :to => 'home#index'

  api_version(
    :module    => "Api::V2",
    :header    => { :name   => "Accept",  :value => "application/vnd.gameworks.io; version=2" },
    :parameter => { :name   => "version", :value => "2" },
    :path      => { :value  => "v2"   },
    :defaults  => { :format => "json" }) do

    get  'public_key', to: 'services#public_key'
    get  'test',       to: 'users#test'
    post 'login',      to: 'users#login'
    post 'register',   to: 'users#create'
    get  'user',       to: 'users#show'
    post 'notify',     to: 'users#send_notification'
    get  'player',     to: 'players#my_player'
    get  'publisher',  to: 'publishers#show'

    resources :users, :except => [:destroy, :show] do
      collection do
        get '/confirm/:code',   to: 'users#confirm'
        get '/:id/resend_code', to: 'users#resend_code'
        get '/:wallet_address', to: 'users#find_player'
      end
    end

    resources :publishers, :except => [:show, :update, :destroy, :index] do
      collection do
        get   '/:user_id', to: 'publishers#show'
        patch '/:user_id', to: 'publishers#update'
        put   '/:user_id', to: 'publishers#update'
      end
    end

    resources :players, :except => [:show, :destroy] do
      collection do
        get   '/:user_id', to: 'players#show'
        patch '/:user_id', to: 'players#update'
        put   '/:user_id', to: 'players#update'
      end
    end

    resources :wallets, :except => [:show] do
      collection do
        get '/:wallet_address', to: 'wallets#show'
        get '/:wallet_address/balance', to: 'wallets#balance'
      end
    end
  end
  root :to => 'home#index'
end
