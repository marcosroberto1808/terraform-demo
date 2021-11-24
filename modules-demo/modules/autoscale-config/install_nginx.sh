#!/bin/bash

# Install Nginx
amazon-linux-extras install nginx1
amazon-linux-extras install epel -y
sudo systemctl enable nginx
sudo systemctl start nginx
sudo yum install git htop stress -y
sudo mkdir -p /myapp/
sudo git clone https://github.com/marcosroberto1808/mywebsite-docker.git /myapp/
sudo mv /usr/share/nginx/html /usr/share/nginx/old_html
sudo cp -R /myapp/html /usr/share/nginx/
sudo curl http://169.254.169.254/latest/meta-data/local-ipv4 -o /usr/share/nginx/html/local-ip.txt
sudo curl http://169.254.169.254/latest/meta-data/local-hostname -o /usr/share/nginx/html/local-hostname.txt
sudo rm -Rf /var/tmp/aws-mon
