Rails.application.routes.draw do

  root 'conversations#index'
  resources :agents
  resources :conversations do
    member do
      get 'increment'
      get 'reset'
    end
  end
  resources :messages
end
