Rails.application.routes.draw do
  post "oauth/callback", to: "oauths#callback"
  get "oauth/callback", to: "oauths#callback"
  get "oauth/:provider", to: "oauths#oauth", as: :auth_at_provider


  namespace :admin do
    root "users#index"
    resources :users
    resources :dashboards, only: %i[index]
    resources :boards do
      member do
        get :board_info
      end
      resources :frames
      resources :comments
    end
    resources :reports
  end
  
  resources :reports do
    member do
      get :new_board_report
      post :create_board_report
      get :new_comment_report
      post :create_comment_report
    end
  end
  resources :users do
    member do
      get :liked_boards
      get :visited_boards
      get :show_profile
      get :user_actions
    end
  end

  resources :password_resets do
    collection do
      get ":token/edit", action: :edit, as: "edit_password_reset"
      post "create", action: :create, as: "password_resets"
      patch "update", action: :update, as: "update_password_reset"
    end
  end

  resources :boards do
    member do
      get :edit_board
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
  resources :likes, only: [ :create, :destroy ]
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

  match "*path", to: "application#raise_not_found", via: :all
end
