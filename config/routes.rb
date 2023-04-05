# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  get 'users/:user_id/awards', to: 'awards#user_awards', as: :user_awards

  concern :votable do
    member do
      post :vote_up
      post :vote_down
    end
  end

  resources :questions, except: :edit, concerns: :votable do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: :votable do
      member do
        post :mark_best
        delete 'delete_file/:file_id', action: :delete_file, as: :delete_file
      end
    end

    member do
      delete 'delete_file/:file_id', action: :delete_file, as: :delete_file
    end
  end

  resources :links, only: :destroy
end
