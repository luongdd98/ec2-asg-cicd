#!/bin/bash
set -e

echo "Starting Flask application deployment..."

# Install Python dependencies
cd /opt/flask-app
source venv/bin/activate

# Upgrade pip first
pip install --upgrade pip

# Install requirements
pip install -r requirements.txt

echo "Python dependencies installed successfully"

# Copy systemd service file
cp flask-app.service /etc/systemd/system/
systemctl daemon-reload

# Copy Apache virtual host config
cp flask-app.conf /etc/httpd/conf.d/

echo "Configuration files copied"

# Start Apache
systemctl start httpd
systemctl enable httpd

echo "Apache started"

# Start Flask app
systemctl start flask-app
systemctl enable flask-app

echo "Flask app service started"

# Wait a moment for services to start
sleep 10

# Check if services are running
if systemctl is-active --quiet httpd; then
    echo "Apache is running"
else
    echo "Apache failed to start"
    systemctl status httpd
    exit 1
fi

if systemctl is-active --quiet flask-app; then
    echo "Flask app is running"
else
    echo "Flask app failed to start"
    systemctl status flask-app
    exit 1
fi

echo "Flask application started successfully"
