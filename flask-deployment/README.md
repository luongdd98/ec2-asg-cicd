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

### 🔧 appspec.yml
**CodeDeploy deployment specification** - Định nghĩa cách CodeDeploy xử lý deployment:
- Copy files từ source đến `/var/www/flask-app`
- Thực hiện lifecycle hooks: BeforeInstall, ApplicationStart, ApplicationStop
- Timeout và error handling configuration

### 🐍 app.py
**Flask application chính** với các tính năng:
- Health check endpoints cho ALB (`/health`)
- API endpoints (`/api/info`, `/api/status`)
- Error handling (404, 500)
- Production-ready configuration
- Environment variables support

### 📦 requirements.txt
**Python dependencies** cần thiết:
- Flask framework
- Gunicorn WSGI server
- Supporting libraries (Werkzeug, Jinja2, etc.)

## 🛠️ Deployment Scripts

### 📥 scripts/install_dependencies.sh
**System setup và dependency installation:**
- Update system packages (yum update)
- Install Python3 và pip
- Create virtual environment
- Install Python packages từ requirements.txt
- Set file permissions

### 🚀 scripts/start_server.sh
**Application startup script:**
- Activate virtual environment
- Set environment variables
- Stop existing processes
- Start Gunicorn server với production config
- Health check validation

### 🛑 scripts/stop_application.sh
**Application shutdown script:**
- Gracefully kill running Flask/Gunicorn processes
- Clean up resources
- Verify processes stopped

### ✅ scripts/validate_service.sh
**Post-deployment validation:**
- Test health endpoint
- Verify main application endpoint
- Check API endpoints
- Ensure all services running correctly

## 🎨 Frontend Components

### templates/index.html
**Main HTML template** displaying:
- Application information (hostname, environment, timestamp)
- Infrastructure features overview
- API endpoint links
- Responsive design

### static/css/style.css
**Modern CSS styling:**
- Responsive grid layout
- Gradient background
- Card-based UI components
- Mobile-friendly design

### static/js/app.js
**JavaScript functionality:**
- Auto-refresh application status
- Interactive API endpoint testing
- Error handling và user feedback

## 🧪 Testing

### tests/test_app.py
**Unit tests coverage:**
- Home page response testing
- Health check endpoint validation
- API endpoints functionality
- Error handling verification

## 🚀 Deployment Automation Scripts

### create-deployment-package.sh
**Tạo deployment package tự động:**
- Create zip file với timestamp
- Exclude các file không cần thiết (.git, __pycache__, logs)
- Verify package contents

### deploy.sh
**Automation deployment script:**
- Create deployment package
- Upload to S3 bucket
- Monitor CodePipeline progress
- Status reporting

## ⚠️ Important Notes

### 🔐 Security Best Practices
- Never commit sensitive data (credentials, keys, passwords)
- Use environment variables for configuration  
- Validate all inputs to prevent security vulnerabilities
- Keep dependencies updated regularly
- Use HTTPS only in production

### 📊 Monitoring & Logs
```bash
# Application logs trên EC2
sudo tail -f /var/log/flask-app/gunicorn.log
sudo tail -f /var/log/flask-app/error.log

# CodeDeploy logs
sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log
```

### 🔧 Common Issues & Solutions

| Issue | Solution |
|-------|----------|
| **Health check failing** | Check logs, verify port 5000 is open |
| **Deployment timeout** | Increase timeout in appspec.yml |
| **Import errors** | Update requirements.txt |
| **Permission denied** | Check file ownership and chmod +x |

### 📞 Troubleshooting Commands
```bash
# Test endpoints manually
curl http://localhost:5000/health

# Check running processes  
ps aux | grep gunicorn

# View CloudWatch logs
aws logs tail /aws/codedeploy/deployments --follow
```