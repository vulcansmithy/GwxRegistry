Rails.application.routes.draw do

  mount Rswag::Ui::Engine  => "/api-docs" if Rails.env.development? || Rails.env.staging?
  mount Rswag::Api::Engine => "/api-docs" if Rails.env.development? || Rails.env.staging?

  api_version(
    :module    => "Api::V1",
    :header    => { :name   => "Accept",  :value => "application/vnd.gameworks.io; version=1" },
    :parameter => { :name   => "version", :value => "1" },
    :path      => { :value  => "v1"   },
    :defaults  => { :format => "json" },
    :default   => true) do

    use_doorkeeper do
      controllers :applications => 'oauth/applications'
    end

    get  'public_key', to: 'services#public_key'
    get  'test',       to: 'users#test'

    resources :auth, :only => [] do
      collection do
        post 'login', to: 'auth#login'
        post 'register', to: 'auth#register'
        post 'forgot', to: 'auth#forgot'
        get 'me', to: 'auth#me'
        post 'confirm/:code', to: 'auth#confirm'
        get 'resend', to: 'auth#resend'
        put 'me', to: 'auth#update'
        post 'notify/:wallet_address', to: 'auth#notify'
      end
    end

    resources :users, :only => [:show, :index]

    resources :publishers, :except => [:update, :destroy, :new, :edit] do
      collection do
        put   '/me',        to: 'publishers#update'
        get   '/me/games',  to: 'publishers#games'
      end
    end

    resources :player_profiles, :except => [:new, :edit] do
      member do
        get '/triggers', to: 'player_profiles#triggers'
      end
    end

    resources :wallets, :except => [:show, :new, :edit] do
      collection do
        get '/:wallet_address', to: 'wallets#show'
        get '/:wallet_address/balance', to: 'wallets#balance'
        get '/:wallet_address/account', to: 'wallets#account'
      end
    end

    resources :games, :except => [:new, :edit] do
      resources :actions, :except => [:new, :edit]
      member do
        get '/player_profiles', to: 'games#player_profiles'
      end
    end

    resources :actions, only: [] do
      member do
        get '/triggers', to: 'actions#triggers'
      end
    end

    resources :triggers, only: :create
  end

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
end
