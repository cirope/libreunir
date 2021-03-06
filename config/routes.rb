Libreunir::Application.routes.draw do

  concern :resources_loans do |options|
    resources :loans, options do
      collection do
        get 'expired', to: 'loans#expired', as: 'expired'
        get 'close_to_expire', to: 'loans#close_to_expire', as: 'close_to_expire'
        get 'not_renewed', to: 'loans#not_renewed', as: 'not_renewed'
        get 'close_to_cancel', to: 'loans#close_to_cancel', as: 'close_to_cancel'
        get 'capital', to: 'loans#capital', as: 'capital'
        get 'prevision', to: 'loans#prevision', as: 'prevision'
      end
    end
  end

  resources :loans, only: [] do
    get '/schedules(/:date)', to: 'schedules#index', as: 'schedules', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
    resources :schedules, only: [:new, :create, :edit, :update]
    resources :taggings, only: [:destroy]
  end

  concerns :resources_loans, only: [:show]

  resources :tags do
    concerns :resources_loans, only: []
    resources :tags, only: [:create, :new]
    resources :taggings, only: [:create]
  end

  resources :zones, only: [] do
    concerns :resources_loans, only: []
  end

  get '/schedules(/:date)', to: 'schedules#index', as: 'schedules', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
  get '/schedules/new(/:date)', to: 'schedules#new', as: 'new_schedule', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
  resources :schedules, except: [:index, :new] do
    put 'mark_as_done', on: :collection, as: 'mark_as_done'
    put 'mark_as_pending', on: :collection, as: 'mark_as_pending'
    put 'move(/:date)', on: :collection, to: 'schedules#move', as: 'move', constraints: { date: /\d{4}-\d{2}-\d{2}/ }
    get 'pending(/:time)', on: :collection, to: 'schedules#pending', as: 'pending', constraints: { time: 'past|future' }
    get 'calendar(/:date)', on: :collection, to: 'schedules#calendar', as: 'calendar', constraints: { date: /\d{4}-\d{2}-\d{2}/ }

    resources :notes, only: [:index, :create]
  end

  devise_for :users

  get :dashboard, to: 'dashboard#index'

  get '/switch/:tenant_id', to: 'users#switch', as: 'switch'
  resources :users do
    member do
      get :edit_profile
      patch :update_profile
    end
  end

  root to: 'dashboard#index'
end
