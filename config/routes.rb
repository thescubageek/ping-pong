Rails.application.routes.draw do
  mount G5Authenticatable::Engine => '/g5_auth'
  get 'welcome/index'

  resources :players
  resources :matches
  resources :logout, only: [:index]

  root 'welcome#index'

  namespace :api do 
    namespace :v1 do

      resources :players, {controller: '/players'}
      match "players", to: '/players#options', via: [:options]
      match "players/:player_id", to: '/players#options', via: [:options]
      resources :matches, {controller: '/matches'}
    end
  end
end

