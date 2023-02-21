#!/usr/bin/env bash

sudo kubeadm init --token 777777.7777777777777777 --apiserver-advertise-address=192.168.0.100 --pod-network-cidr=172.16.0.0/16

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


sudo apt-get -y install bash-completion
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl


echo "alias k=kubectl" | sudo tee -a $HOME/.bashrc
echo "complete -o default -F __start_kubectl k" | sudo tee -a $HOME/.bashrc
source $HOME/.bashrc 

sudo wget https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
sudo sed -i -e 's?10.244.0.0/16?172.16.0.0/16?g' kube-flannel.yml 
kubectl apply -f kube-flannel.yml

#kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/tigera-operator.yaml
#sudo curl -O https://projectcalico.docs.tigera.io/manifests/calico.yaml 
#sudo sed -i -e 's?192.168.0.0/16?172.16.0.0/16?g' calico.yaml
#kubectl apply -f calico.yaml
# kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

