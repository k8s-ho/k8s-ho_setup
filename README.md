# k8s-ho_setup 
Using the vagrantfile I created, you can easily build a Kubernetes environment:)   
This cluster is built with 1 master and 3 workers nodes.

---
### Cluster information (Ubuntu server 20.04)
```bash
https://app.vagrantup.com/imyoungho/boxes/k8s-cluster
```
- kubeadm version 1.25.0 
- kubectl version 1.25.0
- kubelet version 1.25.0


  
### Environmental information
- VirtualBox version: 7.0.6 r155176  
- Vagrant version: 2.3.4

---   


# Usage
```bash
git clone https://github.com/k8s-ho/k8s-ho_setup
cd k8s-ho_setup
sudo vagrant up
```
