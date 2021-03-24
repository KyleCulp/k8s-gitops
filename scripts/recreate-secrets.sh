#!/bin/bash

kubectl delete -f homelab/traefik/certs -f homelab/kube-system/secrets
scripts/create-secret-cert.sh asicforecast-tls asicforecast/cert.pem asicforecast/key.pem traefik
scripts/create-secret-cert.sh kyleculp-tls kyleculp/cert.pem kyleculp/key.pem traefik

scripts/create-secret.sh cloudflare-credentials cloudflare.env traefik
mv priv/build/cloudflare-cresentials.yaml homelab/traefik/cloudflare-credentials.yaml