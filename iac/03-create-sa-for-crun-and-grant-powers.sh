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
set -x
set -e # exists at first error
set -u # fails at first undefined VAR (!!)

########################
# Add your code here
########################

# TODO change this to the CRUN_PROJECT_PNUMBER
SA="932724269481-compute@developer.gserviceaccount.com"

# spec.template.spec.containers[0].env[12].value_from.secret_key_ref.name:
# Permission denied on secret: projects/932724269481/secrets/GENAI_PROD_DB_HOST/versions/latest for Revision service account 932724269481-compute@developer.gserviceaccount.com.
# The service account used must be granted the 'Secret Manager Secret Accessor' role (roles/secretmanager.secretAccessor) at the secret, project or higher level.

# todo ricc (Ive done it manually this time :)




########################
# /End of your code here
########################
_after_allgood_post_script
echo '👍 Everything is ok. But Riccardo you should think about 🌍rewriting it in Terraform🌍'
