#!/bin/bash

#--substitutions=_HOSTNAME=`hostname`
cloud-build-local --config='gcp/cloudbuild.yaml' \
    --dryrun=false \
    .
