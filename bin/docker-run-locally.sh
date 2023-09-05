#!/bin/bash

set -euo pipefail

export RAILS_ENV="${RAILS_ENV:-dev-on-gcp}"
# not needed since they're populated programmatically :)
		# -e APP_DB_NAME="$APP_DB_NAME" \
		# -e APP_DB_USER="$APP_DB_USER" \
		# -e APP_DB_PASS="$APP_DB_PASS" \
		# -e APP_DB_HOST="$APP_DB_HOST" \

set -x

# i provide both DEV and PROD :)
docker run -it -p 30080:8080 \
        -e RAILS_ENV="$RAILS_ENV" \
		-e PROJECT_ID="$PROJECT_ID" \
		-e GCS_BUCKET="$GCS_BUCKET" \
		-e APP_VERSION="$APP_VERSION" \
		-e RAILS_MASTER_KEY="$(cat config/master.key)"  \
		-e APPLICATION_DEFAULT_CREDENTIALS="/sa.json" \
		-e DANGEROUS_SA_JSON_VALUE="$DANGEROUS_SA_JSON_VALUE" \
		-e GOOGLE_TRANSLATE_KEY="$GOOGLE_TRANSLATE_KEY" \
		 "$APP_NAME":v`bin/version.sh` \
		"$@"
