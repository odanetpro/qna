# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  get 'users/:user_id/awards', to: 'awards#user_awards', as: :user_awards
  post 'users/noemail_signup', to: 'users#noemail_signup', as: :noemail_signup

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  concern :commentable do
    resources :comments, only: :create
  end

  resources :questions, except: :edit, concerns: %i[votable commentable] do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: %i[votable commentable] do
      member do
        post :mark_best
        delete 'delete_file/:file_id', action: :delete_file, as: :delete_file
      end
    end

    member do
      delete 'delete_file/:file_id', action: :delete_file, as: :delete_file
      post 'subscribe', to: 'question_subscriptions#create', as: :subscribe
      delete 'unsubscribe', to: 'question_subscriptions#destroy', as: :unsubscribe
    end
  end

  resources :links, only: :destroy

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end

  post 'search', to: 'searches#search', as: :search
end
