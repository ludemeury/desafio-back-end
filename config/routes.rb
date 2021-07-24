Rails.application.routes.draw do
  get 'financial_movements/index'
  post 'financial_movements/upload'
  root 'financial_movements#index'
end
