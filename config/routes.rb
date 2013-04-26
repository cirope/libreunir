Libreunir::Application.routes.draw do
  resources :schedules, except: :destroy do
    patch 'toggle_done', on: :member, as: 'toggle_done'
  end

  devise_for :users

  get :dashboard, to: 'dashboard#index'

  resources :loans, only: [:show] do
    collection do
      get 'expired', to: 'loans#expired', as: 'expired'
      get 'close_to_expire', to: 'loans#close_to_expire', as: 'close_to_expire'
    end

    resources :schedules, only: [:new, :create, :edit, :update]
  end

  resources :users do
    member do
      get :edit_profile
      patch :update_profile
    end
  end

  root to: redirect('/users/sign_in')
end
