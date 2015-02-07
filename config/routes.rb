Rails.application.routes.draw do
  get 'welcome/index'

  resources :players
  resources :matches

  root 'welcome#index'

  namespace :api do 
    namespace :v1 do

      resources :players, {controller: '/players'}
      resources :matches, {controller: '/matches'}
    end
  end
end

