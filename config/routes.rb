Rails.application.routes.draw do
  resources :users

  root 'conversations#index'
  resources :agents
  resources :conversations do
    member do
      post 'increment'
      get 'reset'
      post 'start_simulation'
    end
  end
  resources :messages
  resources :user
  resource :session, only: [:new, :create, :destroy]
  get "signup" => "users#new"
  get "signin" => "sessions#new"

end
