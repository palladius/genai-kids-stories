Rails.application.routes.draw do
  # get ':fix', to: 'translated_stories#fix', as: :translated_story

  # For attachments: https://stackoverflow.com/questions/49515529/rails-5-2-active-storage-purging-deleting-attachments
  # WIP
  resources :attachments do
    member do
      get :destroy
      delete :destroy
      delete :regenerate
      delete :destroy_all
      delete :regenerate_all
    end
  end

  resources :translated_stories do
    # needs collections or wont have DFLT CRUD
    # collection do
    # #   # get :fix_translated_story
    #   post :fix_translated_story
    # end
    member do
      # from 2.10.1 https://guides.rubyonrails.org/routing.html#creating-paths-and-urls-from-objects
      get 'fix'
    end
  end
  devise_for :users
  resources :story_templates
  resources :story_paragraphs do
    member do
      get 'gen_audio'
    end
  end
  get 'pages/index'
  get 'pages/about'
  get 'pages/help'

  # AI functionality
  get 'pages/slow_function'
  post 'pages/slow_function'
  get 'pages/ai_test'
  post 'pages/ai_test'

  resources :stories
  resources :kids
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  #
  #  match '//' # => StoryRebuiltControler
  get '/story_rebuilt/:id', to: 'stories#show_rebuilt', as: 'story_rebuilt'

  match '/delayed_job' => DelayedJobWeb, :anchor => false, :via => %i[get post]

  # fix_translated_story_path
  # get '/fix_translated_story', 'translated_story#fix_translated_story', as: :fix_translated_story

  # Defines the root path route ("/")
  root 'pages#index'
end
