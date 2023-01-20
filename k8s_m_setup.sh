#!/bin/bash

sudo kubeadm init --token 777777.7777777777777777 --apiserver-advertise-address=192.168.0.100 \
--pod-network-cidr=172.16.0.0/16

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

sudo apt-get install bash-completion -y
sudo kubectl completion bash | sudo tee -a /etc/bash_completion.d/kubectl

echo alias k=kubectl | sudo tee -a ~/.bashrc
echo complete -o default -F __start_kubectl k | sudo tee -a ~/.bashrc
source ~/.bashrc 

sudo curl -O https://projectcalico.docs.tigera.io/manifests/calico.yaml 
sudo sed -i -e 's?192.168.0.0/16?172.16.0.0/16?g' calico.yaml
kubectl apply -f calico.yaml
