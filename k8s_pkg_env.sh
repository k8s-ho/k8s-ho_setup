#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install \
   ca-certificates \
   curl \
   gnupg \
   lsb-release

sudo swapoff -a && sudo sed -i '/swap/s/^/#/' /etc/fstab

#sudo systemctl stop firewalld
#sudo systemctl disable firewalld
sudo ufw disable

echo "192.168.0.100 master-k8sHo" | sudo tee -a /etc/hosts
for (( i=1; i<=2; i++  )); do echo "192.168.0.10$i worker$i-k8sHo" | sudo tee -a /etc/hosts; done

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update
sudo apt-get -y install docker-ce docker-ce-cli containerd.io

#sudo mkdir /etc/docker

cat <<EOF | sudo tee /etc/docker/daemon.json
{
   "exec-opts": ["native.cgroupdriver=systemd"],
   "log-driver": "json-file",
   "log-opts": {
      "max-size": "100m"
   },
   "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl start docker

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

cat <<EOF | sudo tee /etc/resolv.conf
nameserver 1.1.1.1 
nameserver 8.8.8.8 
EOF

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet=1.25.0-00 kubeadm=1.25.0-00 kubectl=1.25.0-00
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable kubelet
sudo systemctl restart kubelet
