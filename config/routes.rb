Rails.application.routes.draw do
  resources :donation_services
  devise_for :employees, controllers: {registrations: 'employees/registrations'}
  resources :employees do 
    resources :contributions
    resources :jobs

    post '/dismiss_notifications', to: 'employees#dismiss_notifications'
  end

  # static pages
  get '/about', to: 'static_pages#about'

  root to: redirect('/about')
end
