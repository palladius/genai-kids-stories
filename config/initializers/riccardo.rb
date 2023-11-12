# BEGIN Ricc lib/ APIs.
# require "#{Rails.root}/lib/languages"
# require "#{Rails.root}/lib/ric_utils"
# require "#{Rails.root}/lib/gcp/gcauth"
# require "#{Rails.root}/lib/genai/aiplatform_text_curl"
# require "#{Rails.root}/lib/genai/aiplatform_image_curl"
# require "#{Rails.root}/lib/genai/google_translate"
#require "#{Rails.root}/lib/**"
Dir["#{Rails.root}/lib/*.rb"].each {|f| require f}
Dir["#{Rails.root}/lib/**/*.rb"].each {|f| require f}
# END

# ENV parsing
DEFAULT_PROJECT_ID = 'ricc-genai'

PROJECT_ID = ENV.fetch('PROJECT_ID', DEFAULT_PROJECT_ID) # CloudBuild is hard, yup..
AI_PROJECT_ID = ENV.fetch('AI_PROJECT_ID', DEFAULT_PROJECT_ID) # CloudBuild is hard, yup..
DEFAULT_LANGUAGE = ENV.fetch('DEFAULT_LANGUAGE', 'it')
# raise('I need a project id under PROJECT_ID ENV var!!!') if PROJECT_ID.nil?

GOOGLE_TRANSLATE_KEY = ENV.fetch('GOOGLE_TRANSLATE_KEY', nil)
GOOGLE_TRANSLATE_KEY2 = Rails.application.credentials.dig(:gcp, :google_translate_key)
OCCASIONAL_MESSAGE = ENV.fetch('OCCASIONAL_MESSAGE', nil)

DEFAULT_PARAGRAPH_STRATEGY = 'smart-v0.1'

# Note, we might need to refresh it from time to time :)
# GCLOUD_ACCESS_TOKEN = ENV.fetch(
#   'GCLOUD_ACCESS_TOKEN',
#   `gcloud --project '#{PROJECT_ID}' auth print-access-token`.strip
# )
# if Rails.env == 'dev-on-gcp' && GCLOUD_ACCESS_TOKEN.nil?
#   raise('I need to be able to compute a GCLOUD_ACCESS_TOKEN in GCP mode...!!!')
# end

# bring from bin/docker-run-locally here
# if [ "production" = "$RAILS_ENV" ]; then
# 	echo Configuring PostgreS for PROD
# 	export APP_DB_NAME="$PROD_DB_NAME"
# 	export APP_DB_USER="$PROD_DB_USER"
# 	export APP_DB_PASS="$PROD_DB_PASS"
# 	export APP_DB_HOST="$PROD_DB_HOST"
# else
# 	echo Configuring PostgreS for DEV on GCP or anything else..
# 	export APP_DB_NAME="$DEV_DB_NAME"
# 	export APP_DB_USER="$DEV_DB_USER"
# 	export APP_DB_PASS="$DEV_DB_PASS"
# 	export APP_DB_HOST="$DEV_DB_HOST"
# fi

# NON VA ... pure and simple
# if Rails.env == 'production'
#   ENV['APP_DB_NAME'] = ENV['PROD_DB_NAME']
#   ENV['APP_DB_USER'] = ENV["PROD_DB_USER"]
#   ENV['APP_DB_PASS'] = ENV["PROD_DB_PASS"]
#   ENV['APP_DB_HOST'] = ENV["PROD_DB_HOST"]
# else
#   ENV['APP_DB_NAME'] = ENV['DEV_DB_NAME']
#   ENV['APP_DB_USER'] = ENV["DEV_DB_USER"]
#   ENV['APP_DB_PASS'] = ENV["DEV_DB_PASS"]
#   ENV['APP_DB_HOST'] = ENV["DEV_DB_HOST"]
# end


STORIES_FIXTURE_IMAGES_DIR ||= "#{Rails.root}/db/fixtures/stories/"

# App stuff
APP_NAME = '🤖GenAI 👶🏾Kids 📔Stories'
APP_VERSION = File.read(File.expand_path("#{Rails.root}/VERSION")).chomp

# DB is defined under config/database.yml
# Storage for dev vs dev-on-gcp is defined under config/storage.yml

arzigogolo = '⬢⬡⬢⬡⬢⬡'
database =   Rails.configuration.database_configuration[Rails.env]['adapter']

puts("#{arzigogolo} Welcome to #{APP_NAME} by Riccardo💛Carlesso #{arzigogolo}")
puts("⬢ Thanks for providing GCP Project: '#{PROJECT_ID}'")
puts("⬢ Google Translate key: '#{GOOGLE_TRANSLATE_KEY}'")
puts("⬢ Rails.Env: '#{Rails.env}'")
puts("⬢ Language: '#{DEFAULT_LANGUAGE}'")
puts("⬢ Database:  '#{database}'")
if database == 'postgresql'
  puts("⬢ * [DB] APP_DB_NAME:  '#{ENV['APP_DB_NAME']}'")
  puts("⬢ * [DB] APP_DB_HOST:  '#{ENV['APP_DB_HOST']}'")
  # to remind myself
  puts("⬢ * [DEB] DEV_DB_NAME/PROD_DB_NAME/APP_DB_NAME:  '#{ENV['DEV_DB_NAME']}'/'#{ENV['PROD_DB_NAME']}' => '#{ENV['APP_DB_NAME']}'")
end
# => nil
puts("⬢ ActiveStorage Service:  '#{ Rails.application.config.active_storage.service rescue '?!?' }'")
puts("⬢ ActiveStorage Config:  '#{ Rails.application.config.active_storage.service_configurations[Rails.env] rescue '?!?' }'")
puts(arzigogolo * 12)

class Application < Rails::Application
  config.after_initialize do
    puts("⬢ [after_initialize] ActiveStorage Service: '#{ Rails.application.config.active_storage.service rescue '?!?' }'")
    puts("⬢ [after_initialize] ActiveStorage Config: '#{ Rails.application.config.active_storage.service_configurations[Rails.env] rescue '?!?' }'")
  end
end

# This is SOOOO brilliant! :)
GithubLatestVersion = `curl https://raw.githubusercontent.com/palladius/genai-kids-stories/main/VERSION 2>/dev/null`.chomp rescue nil
GithubLatestVersion ||= '?!?'

# Lets hope this number makes sense here as it does in Kid model :)
ImageUploadMaxSize = 22.megabyte
