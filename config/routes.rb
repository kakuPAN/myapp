Rails.application.routes.draw do
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  resources :users do
    member do
      get :all_users_boards
      get :bookmarked_boards
      get :show_profile
    end
  end
  resources :boards do
    member do
      post :create_like
      delete :destroy_like
      post :create_chat
    end
    resources :frames do
      member do
        patch :move_forward
        patch :move_back
      end
    end
    resources :comments do
      member do
        post :create_reply
      end
    end
  end
  resources :likes, only: [:create, :destroy]
  resources :tasks do
    member do
      patch :achieve_task
      patch :start_task
      patch :reset_task
    end
  end
  root "static_pages#top"
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
end
