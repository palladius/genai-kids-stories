require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GenaiKidsStories
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.autoload_paths += %W[#{config.root}/lib]
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # fixes Zeitwerk issue: https://stackoverflow.com/questions/57277351/rails-6-zeitwerknameerror-doesnt-load-class-from-module
    config.autoloader = :classic

    # Google internal proxy stuff TODO(ricc): abstract so it doesnt clog everyone else..
    config.hosts << /.*\.proxy\.googleprod\.com/
    config.hosts << 'derek.zrh.corp.google.com'
    config.hosts << 'derek.zrh'
    config.hosts << 'localhost'
    config.hosts << 'genai-kids-stories-manhouse-cdlu26pd4q-lz.a.run.app'
    config.hosts << /genai-kids-stories-.*\.a\.run\.app/
    config.hosts << /.*\.palladius\.it/
  end
end
