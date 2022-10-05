#!/bin/bash


### download system dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev unzip webhook git -y


### Download repo with configuration files
wget https://github.com/rubenvoss/server-files-debian-11/archive/refs/heads/main.zip
unzip main.zip
# copies redeploy folder into home folder
cp -r server-files-debian-11-main/redeploy ~


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
sudo cp ~/server-files-debian-11-main/nginx.service /lib/systemd/system/nginx.service
# copy nginx.conf to setup configuration
sudo rm -f /etc/nginx/nginx.conf
sudo cp ~/server-files-debian-11-main/nginx.conf /etc/nginx/nginx.conf
# nginx enable autostart
sudo systemctl enable nginx


### install docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# so you don't have to type sudo before every docker command
sudo usermod -a -G docker admin


### this section sets up webhook
sudo cp ~/server-files-debian-11-main/webhook.service /lib/systemd/system/webhook.service
sudo systemctl enable webhook.service

### this section sets up the docker compose file



### cleaning up
sudo rm -r ~/nginx-1.22.0
sudo rm -r ~/server-files-debian-11-main
rm ~/main.zip
rm ~/nginx-1.22.0.tar.gz


# reboot server
sudo reboot


# remove leftover files
