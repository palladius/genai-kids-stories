
APP_NAME = genai-kids-stories
#APP_VERSION = $(shell cat VERSION)
PROJECT_ID = ricc-genai

install:
# not sure why,,,
	bundle lock --add-platform aarch64-linux
	brew install imagemagick
	#sudo apt-get install imagemagick

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
# docker-build2:
# 	docker build -f Dockerfile -t "$(APP_NAME):v`bin/version.sh`" .



docker-run-bash-nobuild:
	bin/docker-run-locally.sh bash

# No such file or directory - gcloud
docker-run-nobuild:
	bin/docker-run-locally.sh bundle exec rails s -b 0.0.0.0

docker-run: docker-build docker-run-nobuild
docker-run-bash: docker-build docker-run-bash-nobuild

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

run-from-docker:
	APPLICATION_DEFAULT_CREDENTIALS=/sa.json RAILS_ENV=development rails s -b 0.0.0.0

test-postgres:
	echo Story.count | RAILS_ENV='dev-on-gcp' rails console
# attach random Story with GCS image
# s.additional_images.attach(io: File.open(Rails.root.join('app/assets/images/kids/doll.jpg')), filename: 'doll.jpg')

# requires private/sa.json
genai-test-gcs: private/sa.json
	echo 'Story.last.attach_test_image' | rails c

gsutil-images-list:
	gsutil ls gs://$(GCS_BUCKET)/

lint:
	rubocop --lint app/
	rubocop --autocorrect app/ lib/ # app/models/story.rb
