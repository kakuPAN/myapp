Rails.application.routes.draw do
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider

  resources :users do
    member do
      get :liked_boards
      get :visited_boards
      get :show_profile
      get :user_actions
    end
  end
  resources :boards do
    member do
      post :create_like
      delete :destroy_like
      post :create_chat
      get :board_info
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
        delete :destroy_reply
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
  get "privacy_policy", to: "static_pages#privacy_policy"
  get "terms_of_service", to: "static_pages#terms_of_service"
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
end
