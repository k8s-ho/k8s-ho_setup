# -*- mode: ruby -*-
# vi: set ft=ruby :

NodeCount = 3 
k8s_ver = '1.25.0'           

Vagrant.configure("2") do |config|
    config.vm.define "master-k8sHo" do |cfg|
      cfg.vm.box = "imyoungho/k8s-cluster"
      cfg.vm.box_version = "1.0.0"
      cfg.vm.provider "virtualbox" do |vb|
        vb.name = "master-k8sHo{ubuntu_20_04}"
        vb.cpus = 2
        vb.memory = 2048
      end
      cfg.vm.host_name = "master-k8sHo"
      cfg.vm.network "private_network", ip: "192.168.0.100"
      cfg.vm.network "forwarded_port", guest: 22, host: 12340, auto_correct: true, id: "ssh"
      cfg.vm.synced_folder "../data", "/setup", disabled: true 
      cfg.vm.provision "shell", path: "k8s_pkg_env.sh", args: [k8s_ver, NodeCount] 
      cfg.vm.provision "shell", path: "k8s_m_setup.sh"
    end

  (1..NodeCount).each do |i|
    config.vm.define "worker#{i}-k8sHo" do |cfg|
      cfg.vm.box = "imyoungho/k8s-cluster"
      cfg.vm.box_version = "1.0.0"
      cfg.vm.provider "virtualbox" do |vb|
        vb.name = "worker#{i}-k8sHo{ubuntu_20_04}"
        vb.cpus = 1
        vb.memory = 1024
      end
      cfg.vm.host_name = "worker#{i}-k8sHo"
      cfg.vm.network "private_network", ip: "192.168.0.10#{i}"
      cfg.vm.network "forwarded_port", guest: 22, host: "1234#{i}", auto_correct: true, id: "ssh"
      cfg.vm.synced_folder "../data", "/setup", disabled: true
      cfg.vm.provision "shell", path: "k8s_pkg_env.sh", args: [k8s_ver, NodeCount] 
      cfg.vm.provision "shell", path: "k8s_w_setup.sh"
    end
  end
end
