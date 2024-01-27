#!/bin/bash

set -euo pipefail


gcloud auth application-default set-quota-project "$PROJECT_ID"

# echo 1. APIv2

# curl -s -X POST -H "Content-Type: application/json" \
# -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
# –data "{
#   'q': 'The Great Pyramid of Giza (also known as the Pyramid of Khufu or the Pyramid of Cheops) is the oldest and largest of the three pyramids in the Giza pyramid complex.',
#   'source': 'en',
#   'target': 'es',
#   'format': 'text'
# }" https://translation.googleapis.com/language/translate/v2


# google-cloud-translate-v2
cat >PAYLOAD2 <<-EOF
{ "contents": [
    "hello to the whole world"
  ],
  "mimeType": "",
  "sourceLanguageCode": "en",
  "targetLanguageCode": "it" }
EOF

cat PAYLOAD2

echo 2. APIv3

set -x

time curl -s -X POST \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $(gcloud auth application-default print-access-token)" \
    –data @PAYLOAD2 \
    https://translate.googleapis.com/v3beta1/projects/$PROJECT_ID:translateText

echo "ret=$?"

