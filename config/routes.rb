Rails.application.routes.draw do
  resources :vendors
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  get "sessions" => "sessions#new"
  post "sessions" => "sessions#create"
  post "seeds/math" => "seeds#math"
  post "seeds/submit_form" => "seeds#submit_form"

  # Defines the root path route ("/")
  root "seeds#new" #where default goes to
  resources :seeds
end
