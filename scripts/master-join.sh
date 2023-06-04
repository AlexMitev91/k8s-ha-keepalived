# COMMAND TO MANUALLY JOIN MASTER NODE (At this point the command needs to be execute manualy on each secondary master node)
 kubeadm join 192.168.56.10:9090 --token {TOKEN HERE} \
        --discovery-token-ca-cert-hash {CERT HASH HERE} \
        --control-plane --certificate-key {CERT KEY HERE} \
        --apiserver-advertise-address="{IP OF SERVER HERE}"
