Libreunir::Application.routes.draw do

  resources :schedules

  devise_for :users

  get :dashboard, to: 'dashboard#index'

  resources :loans, only: [:show] do
    collection do
      constraints start: /\d{4}-\d{2}-\d{2}/ do
        get 'expired/(:start)', to: 'loans#expired', as: 'expired'
        get 'close_to_expire/(:start)', to: 'loans#close_to_expire', as: 'close_to_expire'
      end
    end

    resources :schedules
  end

  resources :users do
    member do
      get :edit_profile
      patch :update_profile
    end
  end

  root to: redirect('/users/sign_in')
end
