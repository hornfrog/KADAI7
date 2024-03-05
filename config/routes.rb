Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  resources :users, only: [:show, :edit, :update] do
   resources :profiles, only: [:show, :edit, :update]
  end
end
