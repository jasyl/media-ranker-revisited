Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #Omniauth Login Route GITHUB
  get "/auth/github", as: "github_login"

  #Omniauth Login Route GOOGLE
  get "/auth/google_oauth2", as: "google_login"

  #omniauth login
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"

  root "works#root"
  # get "/login", to: "users#login_form", as: "login"
  # post "/login", to: "users#login"
  post "/logout", to: "users#logout", as: "logout"

  resources :works
  post "/works/:id/upvote", to: "works#upvote", as: "upvote"

  resources :users, only: [:index, :show, :create, :destroy]
end
