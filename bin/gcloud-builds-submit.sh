#!/bin/bash

set -euo pipefail

set -x
gcloud --project "$CLOUDBUILD_PROJECT_ID" builds submit --config gcp/cloudbuild.yaml
