#!/usr/bin/env bash

sudo kubeadm init --token 777777.7777777777777777 --token-ttl 0 \
--apiserver-advertise-address=192.168.0.100 --pod-network-cidr=172.16.0.0/16

sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo apt install bash-completion -y
kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl

echo 'alias k=kubectl' | sudo tee -a ~/.bashrc
echo 'complete -o default -F __start_kubectl k'| sudo tee -a ~/.bashrc
source ~/.bashrc 
