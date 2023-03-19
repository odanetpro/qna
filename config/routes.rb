# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'questions#index'

  resources :questions, except: :edit do
    resources :answers, shallow: true, only: %i[show create update destroy]
  end
end
