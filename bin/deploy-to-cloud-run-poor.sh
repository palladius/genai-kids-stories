#!/bin/bash

# This assumes NO ENV at all and can be tested locally :)

set -euo pipefail

echo 'Hi Im a brand new script which needs to be called from Cloud Build and needs to be told ALL variables excplitily'
echo 'Ill start with all being manual and then move to variables one piece at a time'

export ARTIFACT_REPO='europe-north1-docker.pkg.dev/ror-goldie/genai'
UPLOADED_IMAGE="$ARTIFACT_REPO/genai-kids-stories"
UPLOADED_IMAGE_WITH_VER="$UPLOADED_IMAGE:cb-latest"
export REGION="${REGION:-us-central1}"

gcloud --project "$PROJECT_ID" beta run deploy "genai-kids-stories-gcloud-local" \
    --image    "$UPLOADED_IMAGE_WITH_VER" \
    --labels="env=test" \
    --region   "$REGION" \
    --allow-unauthenticated
