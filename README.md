# k8s-ha-keepalived
Vagrant/VB provisioning of a multi-master K8S clusted with Keepalived and HAProxy and stacked/internal etcd. 

By executing "vagrant up" Vagrant will provision one Master K8S server and a number of servers based on the "MASTER_JOIN" and "WORKER_JOIN" variables specified in the Vagrantfile.

Keepalived and HAProxy will be installed and automatically configured on all Master nodes.

Keepalived will create a virtual IP address (192.168.56.10) which will be used as a control endpoint for K8S and HAProxy will distribute the traffic between the Master nodes.

All Worker nodes are automatically joined to the cluster. 

All aditional Master nodes need to be manually joined to the cluster at the moment. To join a master node you need to execute the following command: 

```
 kubeadm join 192.168.56.10:9090 --token {MASTER TOKEN}} \
        --discovery-token-ca-cert-hash {MASTER CERT HASH} \
        --control-plane --certificate-key {MASTER CERT KEY} \
        --apiserver-advertise-address="THE IP ADDRESS OF THE VM TO JOIN"
```

The project is based on the Highly Available Clusters with kubeadm (Stacked etcd) Kubernetes Documentation guidelines: 

https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/high-availability/
