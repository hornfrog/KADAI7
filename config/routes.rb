Rails.application.routes.draw do
  devise_for :users
  root to: "home#index"
  
  resources :users, only: [:show, :edit, :update] do
   resources :profiles, only: [:show, :edit, :update]
  end

  resources :rooms do
    collection do
      get 'search', to: 'rooms#search', as: 'search'
      get 'search_by_area', to: 'rooms#search_by_area', as: 'search_by_area'
    end
    resources :reservations, only: [:index, :new, :create, :destroy]
  end  

  resources :reservations, only: [:index] do
    member do
      get 'confirm'
      delete 'cancel', to: 'reservations#cancel'
      patch 'confirm', to: 'reservations#confirm_reservation'
    end
  end
end
