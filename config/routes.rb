Rails.application.routes.draw do
  resources :stories
  resources :kids
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "stories#index"
end
