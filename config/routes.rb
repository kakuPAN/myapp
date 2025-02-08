Rails.application.routes.draw do
  devise_scope :user do
    get "/users/auth/google_oauth2/callback" => "users/omniauth_callbacks#google_oauth2"
  end
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }, skip: %i[registrations passwords]
  
  
  namespace :admin do
    root "users#index"
    resources :users, except: [ :edit, :update ]
    resources :boards, only: [ :index, :show, :destroy ] do
      member do
        get :board_info
      end
      resources :frames, only: [ :index, :show, :destroy ]
      resources :comments, only: [ :index, :show, :destroy ]
    end
    resources :reports, only: [ :index, :show, :destroy ]
  end

  resources :reports, only: [ :new, :create ] do
    member do
      get :new_board_report
      post :create_board_report
      get :new_comment_report
      post :create_comment_report
    end
  end
  resources :users, except: [ :index, :show ] do
    member do
      get :liked_boards
      get :visited_boards
      get :show_profile
      get :user_actions
    end
  end

  resources :password_resets, except: [ :index, :show, :destroy ] do
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
    resources :frames, except: [ :show ] do
      member do
        patch :move_forward
        patch :move_back
      end
    end
    resources :comments, except: [ :new, :show ] do
      member do
        post :create_reply
        delete :destroy_reply
      end
    end
  end

  root "static_pages#top"
  get "privacy_policy", to: "static_pages#privacy_policy"
  get "terms_of_service", to: "static_pages#terms_of_service"
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  get "*not_found" => "application#routing_error", constraints: lambda { |request| !request.path.include?("active_storage") }
  post "*not_found" => "application#routing_error", constraints: lambda { |request| !request.path.include?("active_storage") }
end
