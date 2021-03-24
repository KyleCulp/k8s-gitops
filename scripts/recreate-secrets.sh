#!/bin/bash

kubectl delete -f homelab/traefik/certs -f homelab/kube-system/secrets
scripts/create-secret-cert.sh asicforecast-tls priv/asicforecast/cert.pem priv/asicforecast/key.pem traefik
scripts/create-secret-cert.sh kyleculp-tls priv/kyleculp/cert.pem priv/kyleculp/key.pem traefik

scripts/create-secret.sh cloudflare-credentials priv/cloudflare.env traefik
mv priv/build/cloudflare-credentials.yaml homelab/traefik/cloudflare-credentials.yaml