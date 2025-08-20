#!/bin/bash
set -e

# Update system
yum update -y

# Install required packages
yum install -y httpd python3 python3-pip python3-venv

# Enable mod_proxy for Apache
echo "LoadModule proxy_module modules/mod_proxy.so" >> /etc/httpd/conf/httpd.conf
echo "LoadModule proxy_http_module modules/mod_proxy_http.so" >> /etc/httpd/conf/httpd.conf

# Create application directory
mkdir -p /opt/flask-app
chown ec2-user:ec2-user /opt/flask-app

# Create virtual environment
cd /opt/flask-app
python3 -m venv venv
chown -R ec2-user:ec2-user /opt/flask-app

echo "Dependencies installed successfully"
