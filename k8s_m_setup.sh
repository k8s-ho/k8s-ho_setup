#!/bin/bash

kubeadm init --token 7777777.77777777777777777 --token-ttl 0 \
--pod-network-cidr=172.16.0.0/16 --apiserver-advertise-address=192.168.0.100 \
--cri-socket=unix:///run/containerd/containerd.sock

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config


apt-install install bash-completion -y
kubectl completion bash >/etc/bash_completion.d/kubectl

echo 'alias k=kubectl' >> ~/.bashrc
echo 'complete -F __start_kubectl k' >> ~/.bashrc


git clone https://github.com/k8s-ho/k8s-ho_setup
mv /home/setup/k8s-ho_setup $HOME
find $HOME/k8s-ho_setup -regex ".*\.\(sh\)" -exec chmod 700 {} \;
