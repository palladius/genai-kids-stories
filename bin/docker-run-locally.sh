#!/bin/bash

set -euo pipefail

export RAILS_ENV="${RAILS_ENV:-dev-on-gcp}"

# not needed since they're populated programmatically :)
if [ "production" = "$RAILS_ENV" ]; then
	echo Configuring PostgreS for PROD
	export APP_DB_NAME="$PROD_DB_NAME"
	export APP_DB_USER="$PROD_DB_USER"
	export APP_DB_PASS="$PROD_DB_PASS"
	export APP_DB_HOST="$PROD_DB_HOST"
else
	echo Configuring PostgreS for DEV on GCP or anything else..
	export APP_DB_NAME="$DEV_DB_NAME"
	export APP_DB_USER="$DEV_DB_USER"
	export APP_DB_PASS="$DEV_DB_PASS"
	export APP_DB_HOST="$DEV_DB_HOST"
fi

set -x

# i provide both DEV and PROD :)
docker run -it -p 30080:8080 \
        -e RAILS_ENV="$RAILS_ENV" \
		-e PROJECT_ID="$PROJECT_ID" \
		-e GCS_BUCKET="$GCS_BUCKET" \
		-e APP_VERSION="$APP_VERSION" \
		-e APP_DB_NAME="$APP_DB_NAME" \
		-e APP_DB_USER="$APP_DB_USER" \
		-e APP_DB_PASS="$APP_DB_PASS" \
		-e APP_DB_HOST="$APP_DB_HOST" \
		-e RAILS_MASTER_KEY="$(cat config/master.key)"  \
		-e APPLICATION_DEFAULT_CREDENTIALS="/sa.json" \
		-e DANGEROUS_SA_JSON_VALUE="$DANGEROUS_SA_JSON_VALUE" \
		-e GOOGLE_TRANSLATE_KEY="$GOOGLE_TRANSLATE_KEY" \
		"$APP_NAME":v`bin/version.sh` \
		"$@"
