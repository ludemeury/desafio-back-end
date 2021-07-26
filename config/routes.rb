# frozen_string_literal: true

Rails.application.routes.draw do
  resources :financial_movements, only: %i[index show destroy] do
    collection do
      post :upload
    end
  end
  root 'financial_movements#index'
end
