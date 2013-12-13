Lmstats::Application.routes.draw do

  resources :features, only: [:index, :show, :edit, :update]

  resources :settings
  resources :usages
  resources :tokens do
    get "plot", on: :collection
  end
  resources :workstations
  resources :users

  resources :lm_status, only: [:create]

  root :to => "home#index"
end
