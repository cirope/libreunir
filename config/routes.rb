Libreunir::Application.routes.draw do
  devise_for :users
 
  get '/dashboard', to: 'dashboard#index'
  post '/dashboard', to: 'dashboard#index'
  
  resources :users do
    member do
      get :edit_profile
      put :update_profile
    end
  end
  
  root to: redirect('/users/sign_in')
end
