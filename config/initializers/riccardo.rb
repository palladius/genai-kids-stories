# for Ricc lib/ APIs.
require "#{Rails.root}/lib/genai/aiplatform_text_curl"

# ENV parsing
PROJECT_ID ||= ENV.fetch('PROJECT_ID') # , '_PROJECT_NON_DATUR_')
# Note, we might need to refresh it from time to time :)
GCLOUD_ACCESS_TOKEN ||= `gcloud --project '#{PROJECT_ID}' auth print-access-token`.strip

STORIES_FIXTURE_IMAGES_DIR ||= "#{Rails.root}/db/fixtures/stories/"

# App stuff
APP_NAME = '🤖GenAI 👶🏾Kids 📔Stories'
APP_VERSION = File.read(File.expand_path("#{Rails.root}/VERSION")).chomp

# Active storage
# ACTIVE_STORAGE_DEV = :local
# ACTIVE_STORAGE_DEV_ON_GCP = :google

# DB is defined under config/database.yml
# Storage for dev vs dev-on-gcp is defined under config/storage.yml
