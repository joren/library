Rails.application.routes.draw do
  resources :books
  resources :authentications, only: [:new, :create]

  get "/login/:auth_token", to: "sessions#create", as: "login"
  get "/logout", to: "sessions#destroy", as: "logout"

  root 'books#index'
end
