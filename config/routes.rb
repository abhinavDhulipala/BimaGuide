require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :employee, ->(emp){emp.super_admin?} do
    mount Sidekiq::Web => 'sidekiq' 
  end
  resources :donation_services
  devise_for :employees, controllers: {registrations: 'employees/registrations'}
  resources :employees do 
    resources :contributions
    resources :claims
    resources :jobs
    resources :elections do
      post 'vote', to: 'elections#vote'
      patch 'vote', to: 'elections#vote'
      post 'veto', to: 'elections#veto'
    end
 
    get 'show_admin', to: 'employees#show_admin'
    post 'dismiss_notifications', to: 'employees#dismiss_notifications'
  end

  # static pages
  get 'about', to: 'static_pages#about'

  root to: redirect('about')
end
