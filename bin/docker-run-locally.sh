#!/bin/bash

set -euo pipefail
# find this

set -x

docker run -p 3000:3000 \
    -e ENV APPLICATION_DEFAULT_CREDENTIALS=/sa.json \
    -e RAILS_ENV=dev-on-gcp \
    rails s -b 0.0.0.0
