#!/bin/sh
if [ $# -eq 0 ]
  then
    exit 1
fi
# /scripts/create-secret-cert.sh asicforecast-tls priv/asicforecast/cert.pem priv/asicforecast/key.pem traefik
kubectl create secret tls $1 --cert $2 --key $3 -n $4 --dry-run=client -o json | \
  kubeseal --cluster k3d-homecluster --controller-name sealed-secrets -o yaml > homelab/kube-system/certs/$1.yaml

echo "'homelab/kube-system/certs-o/$1.yaml' is safe to upload to github"
