#!/bin/bash

set -x

#Pre-pull control plane images
kubeadm config images pull --kubernetes-version=$KUBE_VERSION

#Initiate the cluster as a master node
kubeadm init --control-plane-endpoint="192.168.56.10:9090" --upload-certs --apiserver-advertise-address="192.168.56.11" --pod-network-cidr="172.16.0.0/12" --kubernetes-version=$KUBE_VERSION

#Copy the "kubectl" config files to the home directory
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

#Remove taints (optional)
kubectl taint nodes --all node-role.kubernetes.io/control-plane:NoSchedule- 

#Apply CNI
kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

# OPTION FOR WEAVE INSTEAD OF CALICO
#kubectl --kubeconfig=/etc/kubernetes/admin.conf create -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml

#Export worker-join commnad
kubeadm token create --print-join-command > /vagrant/token-join

# INSTALL HELM3
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# COMMAND TO MANUALLY JOIN MASTER NODE
# kubeadm join 192.168.56.10:9090 --token wnokf7.trlnincoqes06i4t \
#        --discovery-token-ca-cert-hash sha256:0ac13fe5c5f3114d87b1f0d3ed51892fab0d4b43c55883f0d42b76827e0be04d \
#        --control-plane --certificate-key 6b00ab4cb2924661430b6b6a9a49ff4ff9b5613ac6ceb26b8e6dc83dc070701e \
#        --apiserver-advertise-address="192.168.56.12"
