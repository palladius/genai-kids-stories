#!/bin/bash

function _fatal() {
    echo "[FATAL] $*" >&1
    exit 42
}
function _after_allgood_post_script() {
    echo "[$0] All good on $(date)"
    CLEANED_UP_DOLL0="$(basename $0)"
    touch .executed_ok."$CLEANED_UP_DOLL0".touch
}

# Created with codelabba.rb v.2.2
# You can use `direnv allow` to make this work automagically.
source .envrc || _fatal 'Couldnt source this'
set -euo pipefail
#set -e # exists at first error
#set -u # fails at first undefined VAR (!!)

########################
# Add your code here
########################

# image: http://localhost:3000/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBc3dlIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--805d140a070a197beca9f81fe0adcf2cf72f9490/tmp_002-Imagine_a_Rara_is_a_yellow_and_brown_giraffe_toy_Beside_her__Act_1__Once_upon_a_time_there.ix=0.dmi=5320969974389407744.png

set -x
gcloud storage buckets update "gs://$GCS_BUCKET" --cors-file=gcs-cors-file.json

echo Now visualizing it ...

gcloud storage buckets describe gs://$GCS_BUCKET --format="default(cors_config)"

echo 'Resetting PUBLIC access to the bucket... since since b/2 its not anymore :('
gsutil iam ch allUsers:objectViewer gs://$GCS_BUCKET
