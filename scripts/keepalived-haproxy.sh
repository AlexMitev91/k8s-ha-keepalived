#!/bin/bash

sudo apt update -y

sudo apt install -y keepalived haproxy

#KEEPALIVED CONFIGURATION

cat >> /etc/keepalived/check_apiserver.sh <<EOF
#!/bin/sh

errorExit() {
  echo "*** $@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q 192.168.56.10; then
  curl --silent --max-time 2 --insecure https://192.168.56.10:9090/ -o /dev/null || errorExit "Error GET https://192.168.56.10:9090/"
fi
EOF

chmod +x /etc/keepalived/check_apiserver.sh

cat >> /etc/keepalived/keepalived.conf <<EOF
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  timeout 10
  fall 5
  rise 2
  weight -2
}

vrrp_instance VI_1 {
    state BACKUP
    interface enp0s8
    virtual_router_id 1
    priority 100
    advert_int 5
    authentication {
        auth_type PASS
        auth_pass mysecret
    }
    virtual_ipaddress {
        192.168.56.10
    }
    track_script {
        check_apiserver
    }
}
EOF

sudo systemctl enable --now keepalived

#HA PROXY CONFIGURATION

cat >> /etc/haproxy/haproxy.cfg <<EOF

frontend kubernetes-frontend
  bind *:9090
  mode tcp
  option tcplog
  default_backend kubernetes-backend

backend kubernetes-backend
  option httpchk GET /healthz
  http-check expect status 200
  mode tcp
  option ssl-hello-chk
  balance roundrobin
    server master-1 192.168.56.11:6443 check fall 3 rise 2
    server master-2 192.168.56.12:6443 check fall 3 rise 2
    server master-3 192.168.56.13:6443 check fall 3 rise 2

EOF

systemctl enable haproxy && systemctl restart haproxy