#!/bin/bash

if [ "$DANGEROUS_SA_JSON_VALUE" = '' ] ; then
    echo 'Empty DANGEROUS_SA_JSON_VALUE: skipping'
else
    echo "$DANGEROUS_SA_JSON_VALUE" > private/sa-autogenerated.json
fi
