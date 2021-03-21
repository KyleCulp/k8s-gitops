#!/bin/bash
git add .
git commit -m "automated push"
git push
# I just run this every time
flux bootstrap github --verbose \
  --owner=kyleculp --repository=k8s-gitops \
  --branch=master --path=homelab \
  --personal --token-auth

git pull