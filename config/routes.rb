Rails.application.routes.draw do
  resources :donation_services
  devise_for :employees, controllers: {registrations: 'employees/registrations'}
  resources :employees do 
    resources :contributions
    post '/dismiss_notifications', to: 'employees#dismiss_notifications'
  end

  root to: redirect('/employees')
end
