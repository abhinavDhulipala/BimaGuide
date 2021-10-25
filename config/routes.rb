Rails.application.routes.draw do
  devise_for :employees
  resources :employees
  root to: redirect('/about')

  # static routes
  get '/about' => 'employees#about'
end
