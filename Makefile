
APP_NAME = genai-kids-stories
#APP_VERSION = $(shell cat VERSION)
PROJECT_ID = ricc-genai

install:
# not sure why,,,
	bundle lock --add-platform aarch64-linux
	brew install imagemagick
	brew install vips
	#sudo apt-get install imagemagick
	# https://stackoverflow.com/questions/70849182/could-not-open-library-vips-42-could-not-open-library-libvips-42-dylib
	#sudo apt-get install libvips-tools OPPURE libvips-dev E/O ruby-vips
	# Alternatively: config.active_storage.variant_processor = :mini_magick
	# https://packages.debian.org/source/buster/vips

install-linux:
	sudo apt-get install libvips-tools

# .PHONY: help
# help: ## Shows all targets and help from the Makefile (this message).
#         @echo "🤖 This Makefile was also created via GenAI. Just kidding."
#         @echo ""
#         @grep --no-filename -E '^([/a-z.A-Z0-9_%-]+:.*?|)##' $(MAKEFILE_LIST) | \
#                 awk 'BEGIN {FS = "(:.*?|)## ?"}; { \
#                         if (length($$1) > 0) { \
#                                 printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2; \
#                         } else { \
#                                 if (length($$2) > 0) { \
#                                         printf "%s\n", $$2; \
#                                 } \
#                         } \
#                 }'


# Runs local server by forcing a delayed job too :)
run-local: # runs locally after starting a daemon for delayed jobs..
	make delayed-jobs-daemon &
	bundle exec rails s -b 0.0.0.0
run-local-prod: # runs locally after starting a daemon for delayed jobs..
	RAILS_ENV="production" rails assets:precompile

	RAILS_LOG_TO_STDOUT="1" \
    RAILS_SERVE_STATIC_FILES="true" \
    RAILS_ENV="production" \
    BUNDLE_WITHOUT="development" \
	APP_DB_NAME="$(PROD_DB_NAME)" \
	APP_DB_USER="$(PROD_DB_USER)" \
	APP_DB_PASS="$(PROD_DB_PASS)" \
	APP_DB_HOST="$(PROD_DB_HOST)" \
	bundle exec rails s -b 0.0.0.0

run-local-dev-on-gcp:
	RAILS_ENV='dev-on-gcp' make delayed-jobs-daemon &
	RAILS_ENV='dev-on-gcp' bundle exec rails s -b 0.0.0.0

delayed-jobs-start-daemon:
	RAILS_ENV=development bin/delayed_job start -l --logfilename log/riccardo-delayed-jobs.log
delayed-jobs-start-foreground:
	RAILS_ENV=development bin/delayed_job run -l --logfilename log/riccardo-delayed-jobs.log
delayed-jobs-daemon-stop:
	RAILS_ENV=development bin/delayed_job stop
	RAILS_ENV=development bin/delayed_job status

cloud-build-local:
	bin/cloud-build-local.sh
cloud-build-submit:
	gcloud builds submit --config gcp/cloudbuild.yaml

.PHONY: test
test:
	rake test

docker-build:
	docker build -t "$(APP_NAME)":v`bin/version.sh` .


docker-run-bash-nobuild:
	bin/docker-run-locally.sh bash

# No such file or directory - gcloud
docker-run-nobuild:
	bin/docker-run-locally.sh

docker-run: docker-build docker-run-nobuild
docker-run-bash: docker-build docker-run-bash-nobuild

docker-push:
# check for build is inside..
	bin/docker-push
#PHONY: test
tests:
#	rails db:migrate RAILS_ENV=test
	rake test



genai-image-test:
# just a refrerence test to gen image from CLI :)
	echo 'Story.find(74).genai_compute_images!'  | rails c

genai-create-empty-story:
	echo This should trigger all the GenAI bonanza:
	echo 'Story.new(:internal_notes => "cli #{Time.now} on #{`hostname`}", kid: Kid.find_sample).save' | rails c

genai-create-joke:
	@echo This should trigger a joke without kid...
	echo 'Story.new(:internal_notes => "fun joke #{Time.now} on #{`hostname`}", kid: Kid.first, genai_input: "Write a joke about a japanese Software Engineer from Google who walks into a library.\n Make it funny and with some unexpected final plot twist.").save' | rails c
genai-create-joke2:
	echo 'Story.new(:internal_notes => "fun joke 2 #{Time.now} on #{`hostname`}", kid: Kid.last, genai_input: "Write a joke about a swiss hiker going to the mountains.\n Make it funny and with some unexpected final plot twist.").save' | rails c

generate_paragraphs-test:
	echo 'Story.first.generate_paragraphs' | rails c

# Some times it fails.
test-google-translate:
	 echo "google_translate('hello from me', :es)" |  rails c

test-generate-spanish-translation-of-story:
	echo "Story.find(135).generate_paragraphs(lang: 'es')" | rails c
fix-story-17-in-prod:
	echo 'Story.find(17).fix' | RAILS_ENV=production rails c
run-from-docker:
	APPLICATION_DEFAULT_CREDENTIALS=/sa.json RAILS_ENV=development rails s -b 0.0.0.0

test-postgres:
	echo Story.count | RAILS_ENV='dev-on-gcp' rails console
# attach random Story with GCS image
# s.additional_images.attach(io: File.open(Rails.root.join('app/assets/images/kids/doll.jpg')), filename: 'doll.jpg')

test-generate-mock-image:
	# echo "extend Genai::AiplatformImageCurl ; \
	#   ai_curl_images_by_content_v2('001', 'test v1. This string wont be used at all', :mock => true); \
	#   ai_curl_images_by_content_v2('002', 'test v2. This string wont be used either', :mock => true); \
	#   " | rails c
	echo "extend Genai::AiplatformImageCurl ; \
	  ai_curl_images_by_content_v2('002', 'test v2. This string wont be used either', :mock => true); \
	  " | rails c
test-generate-real-image-v1:
	echo "extend Genai::AiplatformImageCurl ; ai_curl_images_by_content_v2('001', 'a dragon in the moat of an enchanted castle', :mock => false)" | rails c
test-generate-real-image-v2:
	echo "extend Genai::AiplatformImageCurl ; ai_curl_images_by_content_v2('002', 'a unicorn drinking a beer', :mock => false)" | rails c
test-generate-real-image-both: test-generate-real-image-v1 test-generate-real-image-v2

# requires private/sa.json
genai-test-gcs: private/sa.json
	echo 'Story.last.attach_test_image' | rails c

gsutil-images-list:
	gsutil ls gs://$(GCS_BUCKET)/ | tee .tmp.gsutil-list
	@echo -en 'Total objects: '
	@cat .tmp.gsutil-list  | wc -l

lint:
	rubocop --lint app/
	rubocop --autocorrect app/ lib/ # app/models/story.rb
clean:
	rm tmp_* ?_tmp_00* .story*json
