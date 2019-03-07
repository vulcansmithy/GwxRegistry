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

    get 'test', to: 'users#test'
    post 'login', to: 'users#login'
    post 'register' => 'users#create'

    resources :users, :except => [:destroy, :index] do
      collection do
        get '/confirm/:code', to: 'users#confirm'
        get '/:id/resend_code', to: 'users#resend_code'
      end
    end

    resources :publishers, :except => [:show, :update, :destroy, :index] do
      collection do
        get   '/:user_id', to: 'publishers#show'
        patch '/:user_id', to: 'publishers#update'
        put   '/:user_id', to: 'publishers#update'
      end
    end

    resources :players, :except => [:show, :destroy, :index] do
      collection do
        get   '/:user_id', to: 'players#show'
        patch '/:user_id', to: 'players#update'
        put   '/:user_id', to: 'players#update'
      end
    end
  end
end
