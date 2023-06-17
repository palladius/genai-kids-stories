
APP_NAME = genai-kids-stories
#APP_VERSION = $(shell cat VERSION)



cloud-build-local:
	bin/cloud-build-local.sh


.PHONY: test
test:
	rake test

docker-build:
	docker build -t "$(APP_NAME):v`bin/version.sh`" .
docker-build2:
	docker build -f Dockerfile.fly-io  -t "$(APP_NAME):v`bin/version.sh`" .



docker-run-nobuild:
	docker run -it -p 3000:3000 "$(APP_NAME):v`bin/version.sh`"

docker-run: docker-build docker-run-nobuild

#PHONY: test
tests:
#	rails db:migrate RAILS_ENV=test
	rake test
