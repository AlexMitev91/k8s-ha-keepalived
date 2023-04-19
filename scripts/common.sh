#!/bin/bash

set -x

KUBE_VERSION=${KUBE_VERSION}
KUBE_PACKAGE_VERSION="$KUBE_VERSION-00"


# Disable swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Setup Kernel modules and sysctl
cat <<EOF | tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sysctl --system

# Get rid of unattended uopgrades
until apt-get remove -y unattended-upgrades
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done

# Install required packages
until apt-get update
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done
until apt install -y curl gnupg2 software-properties-common apt-transport-https ca-certificates
do
        sleep 5
        echo "dpkg lock in place. Attempting install again..."
done

# Enable docker repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmour -o /etc/apt/trusted.gpg.d/docker.gpg
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Install containerd
until apt-get update
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done
until apt-get install -y containerd.io
do
        sleep 5
        echo "dpkg lock in place. Attempting install again..."
done

containerd config default | sudo tee /etc/containerd/config.toml >/dev/null 2>&1
sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
systemctl restart containerd
systemctl enable containerd

# Add Kubernetes repo
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - >/dev/null 2>&1
sudo apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/dev/null 2>&1
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B53DC80D13EDEF05

# Install k8s packages
until apt-get update
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done
until apt-get install -y kubelet=$KUBE_PACKAGE_VERSION kubeadm=$KUBE_PACKAGE_VERSION kubectl=$KUBE_PACKAGE_VERSION
do
        sleep 5
        echo "dpkg lock in place. Attempting install again..."
done
apt-mark hold kubelet kubeadm kubectl
