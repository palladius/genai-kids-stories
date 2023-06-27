Rails.application.routes.draw do
  devise_for :users
  resources :story_templates
  resources :story_paragraphs
  get 'pages/index'
  get 'pages/about'
  get 'pages/help'

  resources :stories
  resources :kids
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #
  #  match '//' # => StoryRebuiltControler
  get '/story_rebuilt/:id', to: 'stories#show_rebuilt', as: 'story_rebuilt'

  match '/delayed_job' => DelayedJobWeb, :anchor => false, :via => %i[get post]

  # Defines the root path route ("/")
  root 'stories#index'
end
