#!/bin/bash

# This assumes NO ENV at all and can be tested locally :)

set -euo pipefail

echo 'Hi Im a brand new script which needs to be called from Cloud Build and needs to be told ALL variables excplitily'
echo 'Ill start with all being manual and then move to variables one piece at a time'

# this is NOT the build project..
export AI_PROJECT_ID=ricc-genai
export ARTIFACT_REPO='europe-north1-docker.pkg.dev/ror-goldie/genai'
UPLOADED_IMAGE="$ARTIFACT_REPO/genai-kids-stories"
UPLOADED_IMAGE_WITH_VER="$UPLOADED_IMAGE:cb-latest"
export REGION="${REGION:-us-central1}"
export GCS_BUCKET='genai-kids-stories-assets'
APP_VERSION="$(bin/version.sh)"
export CLOUD_RUN_SERVICE_NAME=${CLOUD_RUN_SERVICE_NAME:-genai-kids-stories-gcloud-poor}

# I usually build/deploy to project1 and then use AI_PROJECT_ID for AI stuff..
gcloud --project "$PROJECT_ID" beta run deploy "$CLOUD_RUN_SERVICE_NAME" \
    --image    "$UPLOADED_IMAGE_WITH_VER" \
    --set-env-vars="PROJECT_ID=$AI_PROJECT_ID" \
    --set-env-vars="AI_PROJECT_ID=$AI_PROJECT_ID" \
    --set-env-vars="RAILS_ENV=production" \
      --set-env-vars='ACTIVATE_OMEGA13=true' \
      --set-env-vars="GCS_BUCKET=$GCS_BUCKET" \
      --set-env-vars="APPLICATION_DEFAULT_CREDENTIALS=/secrets/sa.json" \
      --set-env-vars="APP_VERSION=$APP_VERSION" \
      \
      --update-secrets=/secrets/sa.json=genai-service-account:latest \
      --update-secrets=DANGEROUS_SA_JSON_VALUE=genai-service-account:latest \
      --update-secrets=RAILS_MASTER_KEY=GENAI_RAILS_MASTER_KEY:latest \
      --update-secrets=GOOGLE_TRANSLATE_KEY=GENAI_GOOGLE_TRANSLATE_KEY:latest \
      --update-secrets=APP_DB_NAME=GENAI_PROD_DB_NAME:latest \
      --update-secrets=APP_DB_USER=GENAI_PROD_DB_USER:latest \
      --update-secrets=APP_DB_PASS=GENAI_PROD_DB_PASS:latest \
      --update-secrets=APP_DB_HOST=GENAI_PROD_DB_HOST:latest \
    --labels="env=test" \
    --labels="gks-tag=poor" \
    --region   "$REGION" \
    --allow-unauthenticated

echo "App v$APP_VERSION succesfully deployed to Cloud run."
