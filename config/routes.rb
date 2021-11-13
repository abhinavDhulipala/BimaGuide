Rails.application.routes.draw do
  devise_for :employees
  resources :employees, :donations
  
  root to: redirect('/employees')
end
