My homelab, using a mix of docker compose and k3s

Router: OPNSense virtualized in proxmox
NGinx reverse proxy to forward traffic / terminate traffic based on SNI. NGinx needs list of domains k3s is using to forward to the cluster. 
Reverse proxy only accepts communication from cloudflare, with cloudflare origins installed on nginx and k3s cluster


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
  homelab \
  --volume /home/k3s/docker/homelab/manifests:/var/lib/rancher/k3s/server/manifests \
  --volume /home/k3s/docker/homelab/storage:/var/lib/rancher/k3s/storage \
  --api-port 192.168.1.123:6550 \
  --port "445:80@loadbalancer" \
  --port "444:443@loadbalancer" \
  --agents 2 \
  --k3s-server-arg --disable --k3s-server-arg traefik
  --k3s-server-arg --kube-apiserver-arg='feature-gates=CSINodeInfo=true,CSIDriverRegistry=true,CSIBlockVolume=true,VolumeSnapshotDataSource=true' \
  --k3s-server-arg --kubelet-arg='feature-gates=CSINodeInfo=true,CSIDriverRegistry=true,CSIBlockVolume=true' 

then follow the commands it has you input after for kubectl config stuff

k3s yaml config gave me permission error, so I just chmod 777'd that hoe and carried on

# flux bootstrap command
flux bootstrap github --verbose \
  --owner=kyleculp --repository=k8s-gitops \
  --branch=master --path=homelab \
  --personal --token-auth

# glooctl (needs python)
    curl -sL https://run.solo.io/gloo/install | sh
    export PATH=$HOME/.gloo/bin:$PATH

ily  https://github.com/lanquarden/roci-gitops/tree/main/cluster/network

# Traefik Ingress
Currently I hate k8s, and after days of rangling treafik w/ k8s I just yeeted in some random config that worked and looked like my old nonworking config so I dunno, but I just configure everything via args really


	--k3s-extra-args "--disable-cloud-controller --no-deploy servicelb --no-deploy traefik --no-deploy local-storage --kubelet-arg='cloud-provider=external' --kubelet-arg=\"provider-id=\"aws:///$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)/$(curl -s http://169.254.169.254/latest/meta-data/instance-id)\"\" --kubelet-arg='feature-gates=CSINodeInfo=true,CSIDriverRegistry=true,CSIBlockVolume=true' --kube-apiserver-arg='allow-privileged=true' --kube-apiserver-arg='feature-gates=CSINodeInfo=true,CSIDriverRegistry=true,CSIBlockVolume=true,VolumeSnapshotDataSource=true' "
