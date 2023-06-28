source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"
#ruby "3.1.2"


############
# Riccardo
gem 'lolcat' # just for fun.
gem "image_processing", ">= 1.2" # for ActiveStorage https://guides.rubyonrails.org/active_storage_overview.html
# From: https://edgeguides.rubyonrails.org/active_storage_overview.html#google-cloud-storage-service
gem "google-cloud-storage", "~> 1.11", require: false
gem 'delayed_job_active_record' # from https://github.com/collectiveidea/delayed_job/
  gem "daemons" # depends on the above
  gem "delayed_job_web" # shows on web too: https://github.com/ejschmitt/delayed_job_web
gem 'postgresql'
gem 'rubocop' # vscode complains otherwise
#gem 'easy_translate'
gem 'google-cloud-translate' # ATTENTZIONE!!!
# downgrades:
# * googleauth (1.6.0) -> becomes   googleauth (0.17.1)
# * faraday (2.7.7) -> becomes  faraday (1.2.0)
gem 'ruby-vips' # needed to makje ActiveStorage work well
# /Riccardo
############


# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.5"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"
  # Ricc: reload CSS and everything :)
  gem 'rails_live_reload'


  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

gem "devise", "~> 4.9"
