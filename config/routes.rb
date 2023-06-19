Rails.application.routes.draw do
  resources :stories
  resources :kids
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]

  # Defines the root path route ("/")
  root "stories#index"
end
