#!/bin/bash

# download system dependencies
sudo apt update
sudo apt upgrade -y
sudo apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev unzip webhook git -y

# Download repo with configuration files
wget https://github.com/rubenvoss/server-files-debian-11/archive/refs/heads/main.zip
unzip main.zip
sudo rm main.zip

### This script installs nginx on a VPS with the Debian 11 OS
# download nginx && install nginx
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
sudo cp ~/devops-rails-main/nginx/nginx.service /lib/systemd/system/nginx.service

# copy nginx.conf to setup configuration
sudo rm -f /etc/nginx/nginx.conf
sudo cp ~/devops-rails-main/nginx/nginx.conf /etc/nginx/nginx.conf

# nginx enable autostart
sudo systemctl enable nginx



### this script installs docker on a VPS with Debian 11 OS
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
# so you don't have to type sudo before every docker command
sudo usermod -a -G docker admin



### this section sets up webhook







# reboot server
sudo reboot


# remove leftover files
