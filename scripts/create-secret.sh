#!/bin/sh
if [ $# -eq 0 ]
  then
    exit 1
fi

kubectl create secret generic $1 --dry-run=client --from-env-file=$2 -n $3 -o json | \
  kubeseal --cluster k3d-homecluster --controller-name sealed-secrets -o yaml > homelab/kube-system/secrets/$1.yaml

echo "'homelab/kube-system/secrets/$1.yaml' is safe to upload to github"
