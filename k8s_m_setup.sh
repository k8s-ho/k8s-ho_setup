#!/bin/bash

sudo kubeadm init --token 777777.7777777777777777 --apiserver-advertise-address=192.168.0.100 \
--pod-network-cidr=192.168.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo apt-get install bash-completion -y
kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl

echo alias k=kubectl | sudo tee -a ~/.bashrc
echo complete -o default -F __start_kubectl k | sudo tee -a ~/.bashrc
source ~/.bashrc 


kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/custom-resources.yaml
