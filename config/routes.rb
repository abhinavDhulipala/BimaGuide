Rails.application.routes.draw do
  resources :employees
  root to: redirect('/about')

  # static routes
  get '/about' => 'employees#about'
end
