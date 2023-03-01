# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :questions do
    resources :answers, shallow: true, only: %i[show new create]
  end
end
