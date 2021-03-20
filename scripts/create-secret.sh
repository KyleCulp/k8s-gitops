#!/bin/bash
echo -n bar | kubectl create secret generic $1 --dry-run=client --from-file=key=/dev/stdin -o json > $1.json

echo "Created generic secret $1.json, add values before continuing"
echo "Make sure you're on the proper cluster w/ kube-seal controller"
echo "Run 'kubeseal <$1.json > $1-sealed.json'"
echo "'$1-sealed.json' is safe to upload to github"
# echo "N is safe to upload to github"
