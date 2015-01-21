Rails.application.routes.draw do
  get 'welcome/index'

  resources :welcome, only: [:index]

  resources :player
  resources :match

  root 'welcome#index'
end
