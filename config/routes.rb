Libreunir::Application.routes.draw do

  devise_for :users
  get :dashboard, to: 'dashboard#index'

  get '/profile/:loan_id', to: 'dashboard#profile', as: 'profile'

  resources :payments, only: [:show] do
    collection do
      constraints start: /\d{4}-\d{2}-\d{2}/ do
        get 'expired/(:start)', to: 'payments#expired', as: 'expired'
        get 'close_to_expire/(:start)', to: 'payments#close_to_expire', as: 'close_to_expire'
      end
    end
  end

  resources :users do
    get :relatives, as: 'relatives', on: :collection

    member do
      get :edit_profile
      patch :update_profile
    end
  end

  root to: redirect('/users/sign_in')
end
