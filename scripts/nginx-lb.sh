#!/bin/bash

set -x

# Get rid of unattended uopgrades
until sudo apt-get remove -y unattended-upgrades -y
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done

# Install required packages
until sudo apt-get update -y
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done

# Install NGINX
until sudo apt-get install nginx -y
do
        sleep 5
        echo "dpkg lock in place. Attempting apt update again..."
done

sudo systemctl enable nginx
sudo systemctl start nginx

sudo mkdir -p /etc/nginx/tcpconf.d
sudo echo "include /etc/nginx/tcpconf.d/*;" >> /etc/nginx/nginx.conf

sudo cp /vagrant/kubernetes.conf /etc/nginx/tcpconf.d/

sudo sudo nginx -s reload