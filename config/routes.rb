Rails.application.routes.draw do
  mount Rswag::Ui::Engine  => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  api_version(
    :module    => 'Api::V1',
    :header    => { :name   => 'Accept',  :value => 'application/vnd.gameworks.io; version=1' },
    :parameter => { :name   => 'version', :value => '1' },
    :path      => { :value  => 'v1'   },
    :defaults  => { :format => 'json' },
    :default   => true) do

    resources :users, :except => [:destroy] do
      collection do
        patch :profile_update
        patch :account_update
        
        post "register", to: "users#register"
        post "login",    to: "users#login"
        get  "test",     to: "users#test"
      end
    end

    resources :publishers, :except => [:show, :update, :destroy] do
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
  end

  post 'auth/register', to: 'users#register'
  post 'auth/login',    to: 'users#login'
  get 'test',           to: 'users#test'
end
