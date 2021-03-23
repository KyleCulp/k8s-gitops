#!/bin/sh
if [ $# -eq 0 ]
  then
    exit 1
fi

kubectl create secret generic $1 --dry-run=client --from-env-file=$2 -n $3 -o json | \
  kubeseal -o yaml > priv/build/$1-secret.yaml

echo "'priv/build/$1-secret.yaml' is safe to upload to github"
