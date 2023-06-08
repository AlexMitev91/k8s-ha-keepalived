# -*- mode: ruby -*-
# vi: set ft=ruby :

KUBE_VERSION="1.26.1"
MASTER_COUNT=1
MASTER_JOIN=1
WORKER_COUNT=1

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.provision "shell", inline: <<-SHELL
  echo "192.168.56.11       master-1" >> /etc/hosts
  echo "192.168.56.12       master-2" >> /etc/hosts
  echo "192.168.56.13       master-3" >> /etc/hosts
  echo "192.168.56.21       worker-1" >> /etc/hosts
  echo "192.168.56.22       worker-2" >> /etc/hosts
  echo "192.168.56.23       worker-3" >> /etc/hosts
  echo "192.168.56.24       worker-4" >> /etc/hosts
  SHELL


  config.vm.define "master1" do |master|
    master.vm.hostname  = "master-1"
    master.vm.provision "shell", path: "./scripts/keepalived-haproxy.sh"
    master.vm.provision "shell", path: "./scripts/common.sh", env: {"KUBE_VERSION" => KUBE_VERSION}
    master.vm.provision "shell", path: "./scripts/master.sh", env: {"KUBE_VERSION" => KUBE_VERSION}
    master.vm.network "private_network", ip: "192.168.56.11"
    master.vm.provider "virtualbox" do |pmv|
      pmv.memory = 2048
    end
  end

1.upto(MASTER_JOIN)do |i|
  config.vm.define "master#{i+1}" do |masterjoin|
    masterjoin.vm.hostname  = "master-#{i+1}"
    masterjoin.vm.provision "shell", path: "./scripts/keepalived-haproxy.sh"
    masterjoin.vm.provision "shell", path: "./scripts/common.sh", env: {"KUBE_VERSION" => KUBE_VERSION}
    masterjoin.vm.network "private_network", ip: "192.168.56.#{i+11}"
    masterjoin.vm.provider "virtualbox" do |pmv|
      pmv.memory = 2048
    end
  end
end

1.upto(WORKER_COUNT) do |i|
    config.vm.define "worker#{i}" do |node|
      node.vm.hostname  = "worker-#{i}"
      node.vm.provision "shell", path: "./scripts/common.sh", env: {"KUBE_VERSION" => KUBE_VERSION}
      node.vm.provision "shell", path: "./scripts/worker.sh"
      node.vm.network "private_network", ip: "192.168.56.#{i+20}"
      node.vm.provider "virtualbox" do |pmv|
        pmv.memory = 1024
      end
    end
  end
end
