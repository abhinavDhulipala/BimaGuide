Rails.application.routes.draw do
  resources :donation_services
  devise_for :employees
  resources :employees do   
    resources :contributions
  end

  root to: redirect('/employees')
end
