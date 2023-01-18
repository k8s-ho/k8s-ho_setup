#!/bin/bash

apt update && apt-get install docker-ce docker-ce-cli docker-compose-plugin -y
apt-get install containerd.io -y 
apt-get install git -y


sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
apt install -y kubelet-$1 kubectl-$1 kubeadm-$1
sudo apt-mark hold kubelet kubeadm kubectl


cat <<EOF > /etc/default/kubelet
KUBELET_KUBEADM_ARGS=--container-runtime=remote \
                     --container-runtime-endpoint=/run/containerd/containerd.sock \
                     --cgroup-driver=systemd
EOF


cat <<EOF > /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
EOF


systemctl enable --now docker
systemctl enable --now containerd
systemctl enable --now kubelet
