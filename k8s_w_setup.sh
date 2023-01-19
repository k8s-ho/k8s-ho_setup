#!/usr/bin/env bash

sudo kubeadm join --token 777777.7777777777777777 \
             --discovery-token-unsafe-skip-ca-verification 192.168.0.100:6443
