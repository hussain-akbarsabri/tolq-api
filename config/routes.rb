# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :glossaries, only: %i[create show index] do
    resources :terms, only: [:create]
  end
  resources :translations, only: %i[create show]
end
