
# for Ricc lib/ APIs.
require "#{Rails.root}/lib/genai/aiplatform_text_curl"

PROJECT_ID ||= ENV.fetch('PROJECT_ID') # , '_PROJECT_NON_DATUR_')
# Note, we might need to refresh it from time to time :)
GCLOUD_ACCESS_TOKEN ||= `gcloud --project '#{PROJECT_ID}' auth print-access-token`.strip

STORIES_FIXTURE_IMAGES_DIR ||= "#{Rails.root}/db/fixtures/stories/"
