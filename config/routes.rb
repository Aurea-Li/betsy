Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'products#root'

  resources :merchants
  resources :products
  resources :order_items
  resources :orders

  resources :sessions, only: [:new, :create]

  get '/auth/:provider/callback', to: "sessions#create", as: 'auth_callback'
  post '/sessions/logout', to: 'sessions#logout', as: 'logout'

end
