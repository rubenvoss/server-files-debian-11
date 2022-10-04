#!/bin/bash

# you have to have downloaded this repo, to have the nginx.service and nginx.conf files available.
# git clone git@github.com:rubenvoss/server-files-debian-11.git
# cd server-files-debian-11

# alternatively you can download the zip file on github and unzip it on the sever:
# sudo apt update
# sudo apt install unzip
# wget https://github.com/rubenvoss/server-files-debian-11/archive/refs/heads/main.zip
# unzip main.zip

# download system dependencies
apt update
apt upgrade -y
apt install build-essential libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev unzip webhook -y

### This script installs nginx on a VPS with the Debian 11 OS
# download nginx && install nginx
wget http://nginx.org/download/nginx-1.22.0.tar.gz
tar -zxvf nginx-1.22.0.tar.gz
cd nginx-1.22.0 || exit
./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log \
            --http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid \
            --with-http_ssl_module
make
make install



# copy nginx.service file to add nginx to systemd
rm -f /lib/systemd/system/nginx.service
cp ~/devops-rails-main/nginx/nginx.service /lib/systemd/system/nginx.service

# copy nginx.conf to setup configuration
rm -f /etc/nginx/nginx.conf
cp ~/devops-rails-main/nginx/nginx.conf /etc/nginx/nginx.conf

# nginx autostart
systemctl enable nginx



### this script installs docker on a VPS with Debian 11 OS
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
# so you don't have to type sudo before every docker command
usermod -a -G docker admin



### this section sets up webhook




# reboot server
reboot



# check for the status of nginx
# systemctl status nginx
# checks for the nginx version, was it installed?
# nginx -V

# remove leftover files
