Rails.application.routes.draw do
  resources :users
  resources :goals do
    resources :tasks do
      member do
        patch :achieve_task
        patch :start_task
        patch :reset_task
      end
    end
  end
  root "static_pages#top"
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
end
