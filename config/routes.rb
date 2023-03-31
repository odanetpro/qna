# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, except: :edit do
    resources :answers, shallow: true, only: %i[create update destroy] do
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
