
APP_NAME = genai-kids-stories
#APP_VERSION = $(shell cat VERSION)



cloud-build-local:
	bin/cloud-build-local.sh


test:
	rake test

docker-build:
	docker build -t "$(APP_NAME):v`bin/version.sh`" .
