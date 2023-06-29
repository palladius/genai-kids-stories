# BEGIN Ricc lib/ APIs.
require "#{Rails.root}/lib/ric_utils"
require "#{Rails.root}/lib/genai/aiplatform_text_curl"
require "#{Rails.root}/lib/genai/google_translate"
# END

# ENV parsing
PROJECT_ID = ENV.fetch('PROJECT_ID') # , '_PROJECT_NON_DATUR_')
DEFAULT_LANGUAGE = ENV.fetch('DEFAULT_LANGUAGE', 'it')
raise('I need a project id under PROJECT_ID ENV var!!!') if PROJECT_ID.nil?

GOOGLE_TRANSLATE_KEY = ENV.fetch('GOOGLE_TRANSLATE_KEY', nil)
GOOGLE_TRANSLATE_KEY2 = Rails.application.credentials.dig(:gcp, :google_translate_key)
OCCASIONAL_MESSAGE = ENV.fetch('OCCASIONAL_MESSAGE', nil)

# Note, we might need to refresh it from time to time :)
GCLOUD_ACCESS_TOKEN = ENV.fetch(
  'GCLOUD_ACCESS_TOKEN',
  `gcloud --project '#{PROJECT_ID}' auth print-access-token`.strip
)
if Rails.env == 'dev-on-gcp' && GCLOUD_ACCESS_TOKEN.nil?
  raise('I need to be able to compute a GCLOUD_ACCESS_TOKEN in GCP mode...!!!')
end

STORIES_FIXTURE_IMAGES_DIR ||= "#{Rails.root}/db/fixtures/stories/"

# App stuff
APP_NAME = '🤖GenAI 👶🏾Kids 📔Stories'
APP_VERSION = File.read(File.expand_path("#{Rails.root}/VERSION")).chomp

# Active storage
# ACTIVE_STORAGE_DEV = :local
# ACTIVE_STORAGE_DEV_ON_GCP = :google

# DB is defined under config/database.yml
# Storage for dev vs dev-on-gcp is defined under config/storage.yml

arzigogolo = '⬢⬡⬢⬡⬢⬡'
database =   Rails.configuration.database_configuration[Rails.env]['adapter']
# rescue StandardError
#  '?'
# end

puts("#{arzigogolo} Welcome to #{APP_NAME} by Riccardo💛Carlesso #{arzigogolo}")
puts("⬢ Thanks for providing GCP Project: '#{PROJECT_ID}'")
puts("⬢ Google Translate key: '#{GOOGLE_TRANSLATE_KEY}'")
puts("⬢ Rails.Env: '#{Rails.env}'")
puts("⬢ Language: '#{DEFAULT_LANGUAGE}'")
puts("⬢ Database:  '#{database}'")
if database == 'postgresql'
  puts("⬢ * APP_DB_NAME:  '#{ENV['APP_DB_NAME']}'")
  puts("⬢ * APP_DB_HOST:  '#{ENV['APP_DB_HOST']}'")
end
puts("⬢ ActiveStorage:  '#{begin
  Rails.application.config.active_storage.service_configurations[Rails.env]
rescue StandardError
  '?!?'
end}'")

puts(arzigogolo * 12)
