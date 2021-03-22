#!/bin/bash
# $1 is the secret name
# $2 is the env file location
echo -n bar | kubectl create secret generic $1 --dry-run=client --from-file=key=/dev/stdin -o json > $1.json

if [ $# -eq 0 ]
  then
    exit 1
fi

if [ -z "$2" ]
  then
    kubectl create secret generic $1 --dry-run=client -o json > $1.json
  else 
    kubectl create secret generic $1 --dry-run=client --from-env-file=$2 -o json > $1.json
    kubeseal --cluster k3d-homecluster --controller-name sealed-secrets <$1.json > homelab/kube-system/secrets/$1.json
fi

echo "Created generic secret $1.json, add values before continuing"
echo "Make sure you're on the proper cluster w/ kube-seal controller"
echo "Run 'kubeseal --cluster k3d-homecluster --controller-name sealed-secrets <$1.json > $1-sealed.json'"
echo "'$1-sealed.json' is safe to upload to github"
# echo "N is safe to upload to github"
echo -n bar | kubectl create secret generic mysecret --dry-run=client --from-file=foo=/dev/stdin -o json \
  | kubeseal  --cluster k3d-homecluster --controller-name sealed-secrets > mysealedsecret.json