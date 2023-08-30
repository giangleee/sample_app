Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do

    # root define
    root "static_pages#home"

    # static page controller
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/microposts", to: "static_pages#home"

    # user controller
    get "/signup", to: "users#new"

    # session controller
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    # resources define
    resources :users
    resources :account_activations, only: :edit
    resources :password_resets, only: %i(new create edit update)
    resources :microposts, only: %i(create destory)
    resources :users do
      resources :followings, only: :index
      resources :followers, only: :index
    end
    resources :relationships, only: %i(create destory)
  end
end
