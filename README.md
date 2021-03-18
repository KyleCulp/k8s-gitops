# k3s-gitops

source secrets.env

flux bootstrap github --owner kyleculp --repository k8s-gitops --branch master --path homelab --personal true

https://github.com/vaskozl/home-infra/blob/main/scripts/update-images.sh