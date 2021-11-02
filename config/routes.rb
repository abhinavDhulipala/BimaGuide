Rails.application.routes.draw do
  resources :donations
  devise_for :employees
  resources :employees
  root to: redirect('/about')

  # static routes
  get '/about' => 'employees#about'
  get '/donate' => 'employees#donate'
end
