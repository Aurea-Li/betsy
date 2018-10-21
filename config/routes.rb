Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :merchants
  resources :products
  resources :order_items, except: [:new]
  resources :orders

  resources :sessions, only: [:new, :create]

  get '/auth/:provider/callback', to: "sessions#create", as: 'auth_callback'
  delete '/logout', to: 'sessions#destroy', as: 'logout'

end
