# Ubuntu -> Vagrant -> K8s Playground
## Prerequisite
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 
- [Vagrant](https://developer.hashicorp.com/vagrant/downloads)

### Lets start
```bash
git clone https://gitlab.com/chavo1/vagrant-k8s.git
cd vagrant-k8s
```

#### Specify k8s version in Vagrantfile

```bash
KUBE_VERSION="1.26.1"
MASTER_COUNT=1
WORKER_COUNT=3
```

#### Check that Kubernetes is up and running

```bash
vagrant ssh master1
sudo -i
root@master-1:~# kubectl get nodes
NAME       STATUS   ROLES           AGE     VERSION
master-1   Ready    control-plane   12m     v1.26.1
worker-1   Ready    <none>          8m57s   v1.26.1
worker-2   Ready    <none>          5m54s   v1.26.1
worker-3   Ready    <none>          2m18s   v1.26.1
```

#### Check helm version
```bash
root@master-1:~# helm version
version.BuildInfo{Version:"v3.11.1", GitCommit:"293b50c65d4d56187cd4e2f390f0ada46b4c4737", GitTreeState:"clean", GoVersion:"go1.18.10"}
```
#### Add some service | I am using [Bitnami's](https://bitnami.com/stack/nginx/helm) packaged NGINX
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install my-release bitnami/nginx
```

```bash
root@master-1:~# curl 172.16.97.193:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

#### Delete deployment
```bash
vagrant destroy -f
```
