#!/bin/bash

apt update && apt full-upgrade -y
curl -fsSL https://get.docker.com | bash
echo "br_netfilter\n
ip_vs_rr\n
ip_vs_wrr\n
ip_vs_sh\n
nf_conntrack_ipv4\n
ip_vs" >> /etc/modules-load.d/k8s.conf
apt update && apt install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list
apt update
apt install -y kubelet kubeadm kubectl
swapoff -a
sed -i 's/^swap\ /#swap\ /g' /etc/fstab

# MASTER
# CPU: 2 RAM: 2GB
hostnamectl set-hotname k8s-master
kubeadm config images pull
kubeadm init
mkdir -p $HOME/.kube

sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
echo "source <(kubectl completion bash)" >> ~/.bashrc

# NODE 01
# CPU: 2 RAM: 1GB
#hostnamectl set-hotname k8s-node01
#kubeadm join --token 39c341.a3bc3c4dd49758d5 192.168.10.10:6443 --discovery-token-ca-cert-hash sha256:37092
#echo "source <(kubectl completion bash)" >> ~/.bashrc

# NODE 02
# CPU: 2 RAM: 1GB
#hostnamectl set-hotname k8s-node02
#kubeadm join --token 39c341.a3bc3c4dd49758d5 192.168.10.10:6443 --discovery-token-ca-cert-hash sha256:37092
#echo "source <(kubectl completion bash)" >> ~/.bashrc
