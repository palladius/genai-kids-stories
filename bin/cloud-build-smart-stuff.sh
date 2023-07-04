#!/bin/bash

function _fatal() {
    echo "[FATAL] $*" >&1
    exit 42
}

set -euo pipefail

# I want to do what cloud build cant do FROM cluod build, like tagging
# smartly the images
ARTIFACT_REPO_ALL="europe-north1-docker.pkg.dev/ror-goldie/genai/genai-kids-stories"
VERSION="$(cat VERSION)"
# Nice substitution https://stackoverflow.com/questions/13210880/replace-one-substring-for-another-string-in-shell-script
# message='The secret code is 12345'
# echo "${message//[0-9]/X}"
DASHED_VERSION="${VERSION//./-}"

# docker tag \
# europe-north1-docker.pkg.dev/ror-goldie/genai/genai-kids-stories \
# europe-north1-docker.pkg.dev/ror-goldie/genai/genai-kids-stories:v0-10-07
docker tag "$ARTIFACT_REPO_ALL" "$ARTIFACT_REPO_ALL:v$DASHED_VERSION"
docker push "$ARTIFACT_REPO_ALL:v$DASHED_VERSION"
