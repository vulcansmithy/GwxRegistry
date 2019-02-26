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

    post 'register' => 'users#create'
    get 'users/confirm/:code' => 'users#confirm'
    get 'users/:id/resend_code' => 'users#resend_code'
    post 'login' => 'users#login'
    get 'test' => 'users#test'

    resources :users, :except => [:destroy]

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
end
