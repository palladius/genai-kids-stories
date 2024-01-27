source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.0'
# ruby "3.1.2"

############
# Riccardo
gem 'image_processing', '>= 1.2' # for ActiveStorage https://guides.rubyonrails.org/active_storage_overview.html
gem 'lolcat' # just for fun.
# From: https://edgeguides.rubyonrails.org/active_storage_overview.html#google-cloud-storage-service
gem 'daemons' # depends on the above
gem 'delayed_job_active_record' # from https://github.com/collectiveidea/delayed_job/
gem 'delayed_job_web' # shows on web too: https://github.com/ejschmitt/delayed_job_web
gem 'google-cloud-storage', '~> 1.11', require: false
gem 'postgresql'
gem 'rubocop' # vscode complains otherwise
# gem 'easy_translate'
gem 'google-cloud-translate' # ATTENTZION!!!
# downgrades:
# * googleauth (1.6.0) -> becomes   googleauth (0.17.1)
# * faraday (2.7.7) -> becomes  faraday (1.2.0)
gem 'redcarpet' # to parse markdown, returned by GenAI
gem 'ruby-vips' # needed to makje ActiveStorage work well
gem 'will_paginate', '~> 4.0' # to paginate too many pages...
# Added bootstrap 5.3.0
# Not strictly needed - i can do it by bash :)
gem 'google-cloud-text_to_speech'
gem 'htmx-rails' # https://github.com/rootstrap/htmx-rails
# gem 'dotenv-rails' to read ENVs.
# /Riccardo
############

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
# gem 'rails', '~> 7.0.5'
gem 'rails', '~> 7.1.3'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
gem 'sqlite3', '~> 1.4'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 6.4.2'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'
  # Ricc: reload CSS and everything :)
  gem 'rails_live_reload'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

gem 'devise', '~> 4.9'

gem 'actionpack', '>= 7.0.5.1'

gem 'cssbundling-rails', '~> 1.2'

gem 'jsbundling-rails', '~> 1.1'
