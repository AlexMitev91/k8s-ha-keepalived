###export commnad
mkdir -p $HOME/.kube
cp -i /vagrant/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/ -R

bash /vagrant/token-join