#!/bin/bash

sudo apt-get update

# install docker, containerd
sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    apt-transport-https
    
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
sudo systemctl enable docker
sudo systemctl start docker


sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF
 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system


sudo systemctl stop firewalld
sudo systemctl disable firewalld


# install kubernetes

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet-$1 kubeadm-$1 kubectl-$1
sudo apt-mark hold kubelet kubeadm kubectl



containerd config default > /etc/containerd/config.toml

cat <<EOF > /etc/default/kubelet
KUBELET_KUBEADM_ARGS=--container-runtime=remote \
                     --container-runtime-endpoint=/run/containerd/containerd.sock \
                     --cgroup-driver=systemd
EOF

cat <<EOF > /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
image-endpoint: unix:///run/containerd/containerd.sock
EOF

sudo systemctl daemon-reload
sudo systemctl restart kubelet

