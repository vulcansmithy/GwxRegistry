Rails.application.routes.draw do

  mount Rswag::Ui::Engine  => "/api-docs" if Rails.env.development? || Rails.env.staging?
  mount Rswag::Api::Engine => "/api-docs" if Rails.env.development? || Rails.env.staging?

  use_doorkeeper do
    controllers :applications => 'oauth/applications'
  end

  api_version(
    :module    => "Api::V1",
    :header    => { :name   => "Accept",  :value => "application/vnd.gameworks.io; version=1" },
    :parameter => { :name   => "version", :value => "1" },
    :path      => { :value  => "v1"   },
    :defaults  => { :format => "json" },
    :default   => true) do

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
        get   '/me/games',  to: 'publishers#my_games'
      end
      member do
        get '/games', to: 'publishers#games'
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
    resources :transfers, only: [:create, :show]
  end
end
