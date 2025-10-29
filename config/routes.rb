Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root 'projects#index'

  resources :projects do
    member do
      post 'add_user'
      delete 'remove_user'
    end
    resources :tickets , only: [:index,:show ,:edit ]
  end

  
  
  resources :tickets do
    member do
      post 'assign_to_self'
      post 'mark_resolved'
      post 'mark_completed'
    end
  end

  
end