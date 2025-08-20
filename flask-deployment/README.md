# 🚀 Flask Application Deployment Package

Thư mục này chứa source code Flask application để deploy lên AWS EC2 thông qua CodeDeploy pipeline.

## 📁 Cấu trúc thư mục

```
flask-deployment/
├── README.md                # Documentation này
├── appspec.yml             # CodeDeploy deployment specification
├── app.py                  # Flask application chính
├── requirements.txt        # Python dependencies
├── scripts/                # Deployment lifecycle scripts
│   ├── install_dependencies.sh    # Install Python packages
│   ├── start_server.sh            # Start Flask application
│   └── stop_application.sh        # Stop running application
├── templates/              # Flask HTML templates (optional)
│   └── index.html
├── static/                 # Static files (CSS, JS, images)
│   ├── css/
│   ├── js/
│   └── images/
└── tests/                  # Unit tests (optional)
    ├── __init__.py
    └── test_app.py
```

## 🎯 Quick Start

### 1. Zip thư mục flask-deployment
```bash
zip -r flask-deployment.zip flask-deployment/
```

### 2. Upload lên S3
```bash
# Upload zip file lên S3 bucket (triggers CodePipeline)
aws s3 cp flask-deployment.zip s3://will-stag-apn1-flask-python-s3/flask-deployment.zip

# Kiểm tra upload thành công
aws s3 ls s3://will-stag-apn1-flask-python-s3/
```

### 3. Monitor deployment
```bash
# Theo dõi CodePipeline
aws codepipeline get-pipeline-state --name will-stag-apn1-flask-python

# Theo dõi CodeDeploy
aws deploy list-deployments --application-name will-stag-apn1-flask-python
```

## 📝 File Configuration

### 🔧 appspec.yml - CodeDeploy Configuration

Định nghĩa cách CodeDeploy xử lý deployment:

```yaml
version: 0.0
os: linux
files:
  - source: /
    destination: /var/www/flask-app
    overwrite: true
file_exists_behavior: OVERWRITE
hooks:
  BeforeInstall:
    - location: scripts/install_dependencies.sh
      timeout: 300
      runas: root
  ApplicationStart:
    - location: scripts/start_server.sh
      timeout: 300
      runas: root
      on-failure: STOP_DEPLOYMENT
  ApplicationStop:
    - location: scripts/stop_application.sh
      timeout: 300
      runas: root
      on-failure: CONTINUE_DEPLOYMENT
  ValidateService:
    - location: scripts/validate_service.sh
      timeout: 300
      runas: root
```

### 🐍 app.py - Flask Application

Production-ready Flask app với health checks:

```python
from flask import Flask, render_template, jsonify, request
import os
import socket
import logging
from datetime import datetime

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

# Configuration
app.config['ENV'] = os.environ.get('FLASK_ENV', 'production')
app.config['DEBUG'] = False
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'your-secret-key-here')

@app.route('/')
def home():
    """Main application page"""
    hostname = socket.gethostname()
    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    return render_template('index.html', 
                         hostname=hostname, 
                         current_time=current_time,
                         environment=app.config['ENV'])

@app.route('/health')
def health_check():
    """Health check endpoint for ALB"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.now().isoformat(),
        'hostname': socket.gethostname(),
        'environment': app.config['ENV']
    }), 200

@app.route('/api/info')
def api_info():
    """API endpoint with application information"""
    return jsonify({
        'application': 'Flask Python AWS Demo',
        'version': '1.0.0',
        'hostname': socket.gethostname(),
        'environment': app.config['ENV'],
        'timestamp': datetime.now().isoformat(),
        'python_version': os.sys.version
    })

@app.route('/api/status')
def api_status():
    """Detailed status endpoint"""
    return jsonify({
        'status': 'running',
        'uptime': 'calculated_uptime_here',
        'memory_usage': 'memory_info_here',
        'requests_count': 'request_counter_here'
    })

@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    logger.error(f'Server Error: {error}')
    return jsonify({'error': 'Internal server error'}), 500

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    host = os.environ.get('HOST', '0.0.0.0')
    
    logger.info(f'Starting Flask app on {host}:{port}')
    app.run(host=host, port=port, debug=False)
```

### 📦 requirements.txt - Dependencies

```txt
Flask==2.3.3
gunicorn==21.2.0
Werkzeug==2.3.7
Jinja2==3.1.2
MarkupSafe==2.1.3
itsdangerous==2.1.2
click==8.1.7
```

## 🛠️ Deployment Scripts

### 📥 install_dependencies.sh

```bash
#!/bin/bash
set -e

echo "=== Installing Python dependencies ==="
cd /var/www/flask-app

# Update system packages
yum update -y
yum install -y python3 python3-pip

# Create virtual environment
if [ ! -d "venv" ]; then
    python3 -m venv venv
    echo "Virtual environment created"
fi

# Activate virtual environment and install dependencies
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt

# Create log directory
mkdir -p /var/log/flask-app
chmod 755 /var/log/flask-app

# Set permissions
chown -R ec2-user:ec2-user /var/www/flask-app
chmod +x scripts/*.sh

echo "Dependencies installed successfully!"
```

### 🚀 start_server.sh

```bash
#!/bin/bash
set -e

echo "=== Starting Flask application ==="
cd /var/www/flask-app

# Activate virtual environment
source venv/bin/activate

# Set environment variables
export FLASK_ENV=production
export FLASK_APP=app.py
export PORT=5000

# Stop any existing processes
pkill -f "gunicorn.*app:app" || true
sleep 2

# Start application with gunicorn
echo "Starting Flask app with gunicorn..."
nohup gunicorn \
    --bind 0.0.0.0:5000 \
    --workers 2 \
    --timeout 60 \
    --keep-alive 5 \
    --max-requests 1000 \
    --max-requests-jitter 100 \
    --preload \
    --access-logfile /var/log/flask-app/access.log \
    --error-logfile /var/log/flask-app/error.log \
    --log-level info \
    app:app > /var/log/flask-app/gunicorn.log 2>&1 &

# Wait for application to start
sleep 5

# Verify application is running
if curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo "Flask application started successfully!"
    echo "Application is running on port 5000"
else
    echo "ERROR: Failed to start Flask application"
    exit 1
fi
```

### 🛑 stop_application.sh

```bash
#!/bin/bash

echo "=== Stopping Flask application ==="

# Kill any running Flask/gunicorn processes
pkill -f "gunicorn.*app:app" || true
pkill -f "python.*app.py" || true

# Wait for processes to stop
sleep 3

# Check if processes are stopped
if pgrep -f "gunicorn.*app:app" > /dev/null; then
    echo "WARNING: Some processes may still be running"
    pkill -9 -f "gunicorn.*app:app" || true
fi

echo "Flask application stopped successfully!"
```

### ✅ validate_service.sh

```bash
#!/bin/bash
set -e

echo "=== Validating Flask application ==="

# Wait for application to be ready
sleep 10

# Test health endpoint
if curl -f http://localhost:5000/health > /dev/null 2>&1; then
    echo "✅ Health check passed"
else
    echo "❌ Health check failed"
    exit 1
fi

# Test main endpoint
if curl -f http://localhost:5000/ > /dev/null 2>&1; then
    echo "✅ Main endpoint accessible"
else
    echo "❌ Main endpoint failed"
    exit 1
fi

# Test API endpoint
if curl -f http://localhost:5000/api/info > /dev/null 2>&1; then
    echo "✅ API endpoint accessible"
else
    echo "❌ API endpoint failed"
    exit 1
fi

echo "🎉 All validation checks passed!"
```

## 🎨 HTML Templates

### templates/index.html

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flask App on AWS</title>
    <link href="{{ url_for('static', filename='css/style.css') }}" rel="stylesheet">
</head>
<body>
    <div class="container">
        <header>
            <h1>🚀 Flask Application on AWS</h1>
            <p class="subtitle">Deployed with CodeDeploy & Auto Scaling</p>
        </header>
        
        <main>
            <div class="info-card">
                <h2>📊 Application Information</h2>
                <div class="info-grid">
                    <div class="info-item">
                        <strong>Hostname:</strong>
                        <span>{{ hostname }}</span>
                    </div>
                    <div class="info-item">
                        <strong>Environment:</strong>
                        <span class="env-{{ environment }}">{{ environment }}</span>
                    </div>
                    <div class="info-item">
                        <strong>Current Time:</strong>
                        <span>{{ current_time }}</span>
                    </div>
                </div>
            </div>
            
            <div class="features">
                <h2>🛠️ Infrastructure Features</h2>
                <ul>
                    <li>✅ Auto Scaling Group with health checks</li>
                    <li>✅ Application Load Balancer with SSL</li>
                    <li>✅ CodeDeploy for automated deployments</li>
                    <li>✅ CloudWatch monitoring and alarms</li>
                    <li>✅ Multi-AZ deployment for high availability</li>
                </ul>
            </div>
            
            <div class="api-endpoints">
                <h2>🔗 API Endpoints</h2>
                <div class="endpoint-list">
                    <a href="/health" class="endpoint">Health Check</a>
                    <a href="/api/info" class="endpoint">Application Info</a>
                    <a href="/api/status" class="endpoint">Status</a>
                </div>
            </div>
        </main>
        
        <footer>
            <p>Built with ❤️ using Flask, Terraform & AWS</p>
        </footer>
    </div>
    
    <script src="{{ url_for('static', filename='js/app.js') }}"></script>
</body>
</html>
```

## 🎨 Static Files

### static/css/style.css

```css
/* Modern CSS styles for Flask app */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    line-height: 1.6;
    color: #333;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
}

.container {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

header {
    text-align: center;
    color: white;
    margin-bottom: 2rem;
}

header h1 {
    font-size: 2.5rem;
    margin-bottom: 0.5rem;
}

.subtitle {
    font-size: 1.2rem;
    opacity: 0.9;
}

main {
    display: grid;
    gap: 2rem;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
}

.info-card, .features, .api-endpoints {
    background: white;
    padding: 1.5rem;
    border-radius: 10px;
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.info-grid {
    display: grid;
    gap: 1rem;
    margin-top: 1rem;
}

.info-item {
    display: flex;
    justify-content: space-between;
    padding: 0.5rem;
    background: #f8f9fa;
    border-radius: 5px;
}

.env-production {
    color: #28a745;
    font-weight: bold;
}

.env-development {
    color: #ffc107;
    font-weight: bold;
}

.features ul {
    list-style: none;
    margin-top: 1rem;
}

.features li {
    padding: 0.5rem 0;
    border-bottom: 1px solid #eee;
}

.endpoint-list {
    display: flex;
    gap: 1rem;
    flex-wrap: wrap;
    margin-top: 1rem;
}

.endpoint {
    padding: 0.5rem 1rem;
    background: #007bff;
    color: white;
    text-decoration: none;
    border-radius: 5px;
    transition: background 0.3s;
}

.endpoint:hover {
    background: #0056b3;
}

footer {
    text-align: center;
    color: white;
    margin-top: 2rem;
    opacity: 0.8;
}

@media (max-width: 768px) {
    .container {
        padding: 10px;
    }
    
    header h1 {
        font-size: 2rem;
    }
    
    main {
        grid-template-columns: 1fr;
    }
}
```

### static/js/app.js

```javascript
// Simple JavaScript for Flask app
document.addEventListener('DOMContentLoaded', function() {
    console.log('Flask App loaded successfully!');
    
    // Auto-refresh timestamp every 30 seconds
    setInterval(function() {
        fetch('/api/info')
            .then(response => response.json())
            .then(data => {
                console.log('App status:', data);
            })
            .catch(error => {
                console.error('Error fetching app status:', error);
            });
    }, 30000);
    
    // Add click event to API endpoints
    document.querySelectorAll('.endpoint').forEach(link => {
        link.addEventListener('click', function(e) {
            if (this.href.includes('/api/')) {
                e.preventDefault();
                fetch(this.href)
                    .then(response => response.json())
                    .then(data => {
                        alert(JSON.stringify(data, null, 2));
                    })
                    .catch(error => {
                        alert('Error: ' + error.message);
                    });
            }
        });
    });
});
```

## 🧪 Testing

### tests/test_app.py

```python
import unittest
import json
from app import app

class FlaskAppTestCase(unittest.TestCase):
    def setUp(self):
        self.app = app.test_client()
        self.app.testing = True

    def test_home_page(self):
        """Test home page loads successfully"""
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)

    def test_health_check(self):
        """Test health check endpoint"""
        response = self.app.get('/health')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['status'], 'healthy')

    def test_api_info(self):
        """Test API info endpoint"""
        response = self.app.get('/api/info')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIn('application', data)
        self.assertIn('version', data)

    def test_404_error(self):
        """Test 404 error handling"""
        response = self.app.get('/nonexistent')
        self.assertEqual(response.status_code, 404)

if __name__ == '__main__':
    unittest.main()
```

## 🚀 Deployment Automation Scripts

### create-deployment-package.sh

```bash
#!/bin/bash
set -e

echo "🔄 Creating Flask deployment package..."

# Variables
PACKAGE_NAME="flask-app-deployment-$(date +%Y%m%d-%H%M%S).zip"
EXCLUDE_PATTERNS="*.git* *.pyc *__pycache__* README.md tests/ *.log"

# Create deployment package
echo "📦 Creating zip package: $PACKAGE_NAME"
zip -r "../$PACKAGE_NAME" . -x $EXCLUDE_PATTERNS

# Verify package contents
echo "📋 Package contents:"
unzip -l "../$PACKAGE_NAME"

echo "✅ Deployment package created: $PACKAGE_NAME"
echo "📤 Ready to upload to S3!"
```

### deploy.sh

```bash
#!/bin/bash
set -e

# Configuration
S3_BUCKET="will-stag-apn1-flask-python-s3"
PACKAGE_NAME="source.zip"
PIPELINE_NAME="will-stag-apn1-flask-python"

echo "🚀 Starting deployment process..."

# Create deployment package
./create-deployment-package.sh

# Get the latest package
LATEST_PACKAGE=$(ls -t ../flask-app-deployment-*.zip | head -n1)

# Upload to S3
echo "📤 Uploading to S3: s3://$S3_BUCKET/$PACKAGE_NAME"
aws s3 cp "$LATEST_PACKAGE" "s3://$S3_BUCKET/$PACKAGE_NAME"

# Monitor pipeline
echo "👀 Monitoring CodePipeline: $PIPELINE_NAME"
aws codepipeline get-pipeline-state --name "$PIPELINE_NAME"

echo "✅ Deployment initiated successfully!"
echo "🔗 Monitor progress in AWS Console"
```

## ⚠️ Important Notes

### 🔐 Security Best Practices

1. **Never commit sensitive data** (credentials, keys, passwords)
2. **Use environment variables** for configuration
3. **Validate all inputs** to prevent security vulnerabilities
4. **Keep dependencies updated** regularly
5. **Use HTTPS only** in production

### 📊 Monitoring & Logs

```bash
# View application logs on EC2
sudo tail -f /var/log/flask-app/gunicorn.log
sudo tail -f /var/log/flask-app/error.log
sudo tail -f /var/log/flask-app/access.log

# View CodeDeploy logs
sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log
```

### 🔧 Troubleshooting

| Issue | Possible Cause | Solution |
|-------|----------------|----------|
| **Health check failing** | App not responding | Check logs, verify port 5000 is open |
| **Deployment timeout** | Script taking too long | Increase timeout in appspec.yml |
| **Import errors** | Missing dependencies | Update requirements.txt |
| **Permission denied** | File permissions | Check file ownership and chmod +x |

---

**📞 Need Help?**
- Check CloudWatch logs for detailed error messages
- Review CodeDeploy deployment events
- Test endpoints manually: `curl http://localhost:5000/health`
- Verify process is running: `ps aux | grep gunicorn`