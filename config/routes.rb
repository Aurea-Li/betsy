Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :merchants

  resources :sessions, only: [:new, :create]

  get '/auth/:provider/callback', to: "sessions#create"
  post '/sessions/logout', to: 'sessions#logout', as: 'logout'
end
