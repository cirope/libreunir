Libreunir::Application.routes.draw do

  devise_for :users
 
  get :dashboard, to: 'dashboard#index'
  post :dashboard, to: 'dashboard#index'

  get '/expiring_info/:id', to: 'dashboard#expiring_info', as: 'expiring_info'

  get :expired, to: 'dashboard#expired', as: 'expired'
  post :expired, to: 'dashboard#expired', as: 'expired'
  get :close_to_expire, to: 'dashboard#close_to_expire', as: 'close_to_expire'
  post :close_to_expire, to: 'dashboard#close_to_expire', as: 'close_to_expire'

  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
