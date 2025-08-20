#!/bin/bash
# Stop Flask application
systemctl stop flask-app || true

# Stop Apache
systemctl stop httpd || true

echo "Services stopped"
