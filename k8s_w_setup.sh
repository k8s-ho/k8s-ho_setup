#!/bin/bash

kubeadm join --token 777777.7777777777777777 \
             --discovery-token-unsafe-skip-ca-verification 192.168.0.100:6443 \
             --cri-socket=unix:///run/containerd/containerd.sock
