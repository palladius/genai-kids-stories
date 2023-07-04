#!/bin/bash

# This script sets up some ENV vars which are to be consumed by Cloud Build (and hopefully also
# Cloud run).
#
# Docs: https://cloud.google.com/sdk/gcloud/reference/secrets/create

set -euo pipefail

LABELS='app=genai-kid-stories'
GCLOUD="gcloud --project $CLOUDRUN_PROJECT_ID"


# GTranslate info
echo "$GOOGLE_TRANSLATE_KEY" | $GCLOUD secrets create GENAI_GOOGLE_TRANSLATE_KEY --data-file=- --labels="$LABELS"

$GCLOUD secrets create GENAI_RAILS_MASTER_KEY --data-file=config/master.key --labels="$LABELS"
$GCLOUD secrets create  GENAI_APPLICATION_DEFAULT_CREDENTIALS --data-file=private/sa.json --labels="$LABELS"

# PostgreS info
echo "$PROD_DB_NAME" | $GCLOUD secrets create GENAI_PROD_DB_NAME --data-file=- --labels="$LABELS"
echo "$PROD_DB_USER" | $GCLOUD secrets create GENAI_PROD_DB_USER --data-file=- --labels="$LABELS"
echo "$PROD_DB_PASS" | $GCLOUD secrets create GENAI_PROD_DB_PASS --data-file=- --labels="$LABELS"
echo "$PROD_DB_HOST" | $GCLOUD secrets create GENAI_PROD_DB_HOST --data-file=- --labels="$LABELS"

