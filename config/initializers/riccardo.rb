
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
# :development
# ACTIVE_STORAGE_DEV = :local
# ACTIVE_STORAGE_PROD = :local
# # dev-on-gcp
#ACTIVE_STORAGE_DEV = :google
#ACTIVE_STORAGE_PROD = :google
