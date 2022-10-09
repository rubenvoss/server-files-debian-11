#!/bin/bash

### download system dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev unzip webhook git -y

### set timezone to berlin
sudo timedatectl set-timezone Europe/Berlin

### this section sets up webhook & docker compose file
sudo mkdir /opt/webhook
sudo cp ~/server_files/webhook.service /lib/systemd/system/webhook.service
sudo cp ~/server_files/hooks.json /opt/webhook/
sudo cp ~/server_files/redeploy.sh /opt/webhook/
sudo cp ~/server_files/docker-compose.yml /opt/webhook/
sudo chmod +x /opt/webhook/redeploy.sh
sudo systemctl enable webhook.service

### download nginx && install nginx
wget http://nginx.org/download/nginx-1.22.0.tar.gz
tar -zxvf nginx-1.22.0.tar.gz
cd nginx-1.22.0 || exit
./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid \
            --with-http_ssl_module
sudo make
sudo make install
# copy nginx.service file to add nginx to systemd
sudo rm -f /lib/systemd/system/nginx.service
sudo cp ~/server_files/nginx.service /lib/systemd/system/nginx.service
# copy nginx.conf to setup configuration
sudo rm -f /etc/nginx/nginx.conf
sudo cp ~/server_files/nginx.conf /etc/nginx/nginx.conf
# nginx enable autostart
sudo systemctl enable nginx

### install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# so you don't have to type sudo before every docker command
sudo usermod -a -G docker admin

### cleaning up
sudo rm -r ~/nginx-1.22.0
sudo rm -r ~/server_files
rm ~/main.zip
rm ~/nginx-1.22.0.tar.gz

### reboot server
sudo reboot
