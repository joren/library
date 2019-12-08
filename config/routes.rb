Rails.application.routes.draw do
  resources :books do
    collection do
      get :recent
      get "from/:user_id", to: "books#user", as: "user"
    end
    member do
      get :download
      post "toggle_read"
    end
  end
  resources :authentications, only: [:new, :create]

  get "/login/:auth_token", to: "sessions#create", as: "login"
  get "/logout", to: "sessions#destroy", as: "logout"

  root 'books#recent'
end
