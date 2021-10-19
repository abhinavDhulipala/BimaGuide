Rails.application.routes.draw do
  resources :employees
  root to: 'employees#index'
end
