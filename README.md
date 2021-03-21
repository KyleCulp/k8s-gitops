project dependencies:
- docker
- k3d
- flux
- yq
- kubeseal
- kubevalidate
- kustomize

# docker quick install script (you can see I've not bothered to learn  about permissions too much)
curl https://releases.rancher.com/install-docker/20.10.sh   | sh
  sudo groupadd docker
  sudo gpasswd -a $USER docker
  sudo usermod -aG docker $USER

  #still had docker perm issues after rebooting, so i did this next coz: https://askubuntu.com/a/1293601
  sudo chown root:docker /var/run/docker.sock
  sudo chown -R root:docker /var/run/docker

# k3d cluster creation command
k3d cluster create \
  homecluster \
  --volume /home/k3s/docker/k3s/manifests:/var/lib/rancher/k3s/server/manifests \
  --volume /home/k3s/docker/k3s/storage:/var/lib/rancher/k3s/storage \
  --api-port 192.168.1.123:6550 \
  --port "80:80@loadbalancer" \
  --port "443:443@loadbalancer" \
  --agents 2 \
  --k3s-server-arg --disable \
  --k3s-server-arg traefik

then follow the commands it has you input after for kubectl config stuff

k3s yaml config gave me permission error, so I just chmod 777'd that hoe and carried on

# flux bootstrap command
flux bootstrap github --verbose \
  --owner=kyleculp --repository=k8s-gitops \
  --branch=master --path=homelab \
  --personal --token-auth