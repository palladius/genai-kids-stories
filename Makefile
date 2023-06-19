
APP_NAME = genai-kids-stories
#APP_VERSION = $(shell cat VERSION)
PROJECT_ID = ricc-genai


# Runs local server by forcing a delayed job too :)
run-local:
	make delayed-jobs-daemon &
	bundle exec rails s -b 0.0.0.0

delayed-jobs-daemon-start:
	bin/delayed_job start -l --logfilename log/riccardo-delayed-jobs.log
delayed-jobs-daemon-stop:
	bin/delayed_job stop
	sleep 1
	ps aux | grep delayed_job

cloud-build-local:
	bin/cloud-build-local.sh


.PHONY: test
test:
	rake test

docker-build:
	docker build -t "$(APP_NAME)":v`bin/version.sh` .
docker-build2:
	docker build -f Dockerfile.fly-io  -t "$(APP_NAME):v`bin/version.sh`" .



docker-run-bash-nobuild:
	docker run -it -p 30080:3000  -e PROJECT_ID=$(PROJECT_ID) "$(APP_NAME)":v`bin/version.sh` bash
	# bundle exec rails s
# No such file or directory - gcloud
docker-run-nobuild:
	docker run -it -p 30080:3000 -e PROJECT_ID=$(PROJECT_ID) "$(APP_NAME)":v`bin/version.sh`  bundle exec rails s

docker-run: docker-build docker-run-nobuild
docker-run-bash: docker-build docker-run-bash-nobuild

#PHONY: test
tests:
#	rails db:migrate RAILS_ENV=test
	rake test
