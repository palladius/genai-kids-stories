#!/bin/bash

set -euo pipefail
# find this

set -euo pipefail

set -x

export RAILS_ENV="${RAILS_ENV:-dev-on-gcp}"
# docker run -it -p 3000:3000 \
#     rails s -b 0.0.0.0


docker run -it -p 30080:8080 \
		-e PROJECT_ID="$PROJECT_ID" \
        -e RAILS_ENV="$RAILS_ENV" \
		-e RAILS_MASTER_KEY="$(cat config/master.key)"  \
		-e APPLICATION_DEFAULT_CREDENTIALS="/sa.json" \
		-e APP_DB_NAME="$APP_DB_NAME" \
		-e APP_DB_USER="$APP_DB_USER" \
		-e APP_DB_PASS="$APP_DB_PASS" \
		-e APP_DB_HOST="$APP_DB_HOST" \
		-e APP_VERSION="$APP_VERSION" \
		-e GOOGLE_TRANSLATE_KEY="$GOOGLE_TRANSLATE_KEY" \
		 "$APP_NAME":v`bin/version.sh` \
		"$@"


		# lets leverage the entrypoint naturally :)
		#  \		${*:-rails s -b 0.0.0.0}

#	docker run -it -p 30080:3000 -e PROJECT_ID=$PROJECT_ID "$(APP_NAME)":v`bin/version.sh`
