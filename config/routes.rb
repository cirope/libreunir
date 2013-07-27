Libreunir::Application.routes.draw do

  resources :tags do
    resources :loans, only: [] do
      collection do
        get 'expired', to: 'loans#expired', as: 'expired'
        get 'close_to_expire', to: 'loans#close_to_expire', as: 'close_to_expire'
      end
    end

    resources :tags, only: [:create, :new]
    resources :taggings, only: [:create]
  end

  resources :zones, only: [] do
    resources :loans, only: [] do
      collection do
        get 'expired', to: 'loans#expired', as: 'expired'
        get 'close_to_expire', to: 'loans#close_to_expire', as: 'close_to_expire'
      end
    end
  end

  get '/schedules(/:date)', to: 'schedules#index', as: 'schedules', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
  get '/schedules/new(/:date)', to: 'schedules#new', as: 'new_schedule', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
  resources :schedules, except: [:index, :new] do
    put 'done', on: :collection, as: 'done'
    put 'pending', on: :collection, as: 'pending'
    put 'move(/:date)', on: :collection, to: 'schedules#move', as: 'move', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
    get 'search(/:date)', on: :collection, to: 'schedules#search', as: 'search', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
    get 'calendar(/:date)', on: :collection, to: 'schedules#calendar', as: 'calendar', constraints: { date: /\d{4}-\d{2}-\d{2}/ }

    resources :notes, only: [:index, :create]
  end

  devise_for :users

  get :dashboard, to: 'dashboard#index'

  resources :loans, only: [:show] do
    collection do
      get 'expired', to: 'loans#expired', as: 'expired'
      get 'close_to_expire', to: 'loans#close_to_expire', as: 'close_to_expire'
    end

    resources :schedules, only: [:new, :create, :edit, :update]
    resources :taggings, only: [:destroy]
  end

  resources :users do
    member do
      get :edit_profile
      patch :update_profile
    end
  end

  root to: redirect('/users/sign_in')
end
