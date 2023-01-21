#!/usr/bin/env bash

sudo kubeadm init --token 777777.7777777777777777 --apiserver-advertise-address=192.168.0.100 --pod-network-cidr=172.16.0.0/16

mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown $(id -u):$(id -g) /home/vagrant/.kube/config


sudo apt-get -y install bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl


echo "alias k=kubectl" | sudo tee -a /home/vagrant/.bashrc
echo "complete -o default -F __start_kubectl k" | sudo tee -a /home/vagrant/.bashrc
source /home/vagrant/.bashrc 


sudo curl -O https://projectcalico.docs.tigera.io/manifests/calico.yaml 
sudo sed -i -e 's?192.168.0.0/16?172.16.0.0/16?g' calico.yaml
kubectl apply -f calico.yaml

