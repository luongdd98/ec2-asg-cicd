#!/bin/bash
yum update -y
yum install -y ruby wget

# Install CodeDeploy agent
cd /home/ec2-user
wget https://aws-codedeploy-${aws_region}.s3.${aws_region}.amazonaws.com/latest/install
chmod +x ./install
./install auto

# Start CodeDeploy agent
service codedeploy-agent start
chkconfig codedeploy-agent on

# Install Python and Flask dependencies
yum install -y python3 python3-pip
pip3 install flask

# Create a simple Flask app directory
mkdir -p /var/www/flask-app
chown ec2-user:ec2-user /var/www/flask-app

# Create a simple Flask application
cat > /var/www/flask-app/app.py << 'EOF'
from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello World! App is running successfully.', 200

@app.route('/health')
def health():
    return 'OK', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
EOF

# Create systemd service for Flask app
cat > /etc/systemd/system/flask-app.service << 'EOF'
[Unit]
Description=Flask Application
After=network.target

[Service]
Type=simple
User=ec2-user
WorkingDirectory=/var/www/flask-app
ExecStart=/usr/bin/python3 app.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Set permissions and start the Flask app
chown ec2-user:ec2-user /var/www/flask-app/app.py
chmod +x /var/www/flask-app/app.py

# Enable and start Flask service
systemctl daemon-reload
systemctl enable flask-app
systemctl start flask-app

# Verify service is running
sleep 5
systemctl status flask-app
