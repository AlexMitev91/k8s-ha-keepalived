# COMMAND TO MANUALLY JOIN MASTER NODE (At this point the command needs to be execute manualy on each secondary master node)
 kubeadm join 192.168.56.10:9090 --token 952ef0.tmuf8y8e51nfso6g \
        --discovery-token-ca-cert-hash sha256:4e7e8aa37ede1cc8efdcfb0f34dce34ba7b15726a8eeae11d208ca237d66ac1d \
        --control-plane --certificate-key 52903ed32dc455c95d83064aff99f9b4bda7b84493323f5d07052eca21c86194 \
        --apiserver-advertise-address="192.168.56.12"