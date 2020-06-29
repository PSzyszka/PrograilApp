Rails.application.routes.draw do
  root 'homepage#index'
  devise_for :users, controllers: { omniauth_callback: 'omniauth_callback' }

  resources :restaurants, except: [:show, :new]
  resources :subscriptions, only: [:new, :create]
  resources :slack_channels, except: [:show, :new]
  get '/confirm_email', to: 'subscriptions#confirm_email'
  get '/posts', to: 'posts#index'
  get '/auth/:provider/callback', to: 'sessions#create'

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
end
