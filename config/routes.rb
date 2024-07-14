Rails.application.routes.draw do
  resources :agents
  resources :conversations do
    member do
      get 'increment'
    end
  end
  resources :messages
end
