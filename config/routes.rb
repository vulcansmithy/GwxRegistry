Rails.application.routes.draw do
  api_version(
    :module    => "Api::V1", 
    :header    => { :name   => "Accept",  :value => "application/vnd.gameworks.io; version=1" }, 
    :parameter => { :name   => "version", :value => "1" }, 
    :path      => { :value  => "v1"   }, 
    :defaults  => { :format => "json" }, 
    :default   => true) do

    resources :users, :except => [:destroy] 

    resources :publishers, :except => [:show, :update, :destroy] do
      collection do
        get   "/:user_id", to: "publishers#show"
        patch "/:user_id", to: "publishers#update"
        put   "/:user_id", to: "publishers#update"
      end
    end
    
    resources :players, :except => [:show, :update, :destroy] do
      collection do
        get   "/:user_id", to: "players#show"
        patch "/:user_id", to: "players#update"
        put   "/:user_id", to: "players#update"
      end
    end
  end
end
