#!/usr/bin/env python3
from flask import Flask, render_template_string
import socket
import datetime
import os

app = Flask(__name__)

# HTML template
HTML_TEMPLATE = '''
<!DOCTYPE html>
<html>
<head>
    <title>Flask App - CodeDeploy Success</title>
    <style>
        body { 
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; 
            margin: 0; 
            padding: 40px; 
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container { 
            max-width: 900px; 
            margin: 0 auto; 
            background: rgba(255,255,255,0.1); 
            padding: 40px; 
            border-radius: 15px; 
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
        }
        h1 { 
            color: #fff; 
            text-align: center; 
            font-size: 2.5em;
            margin-bottom: 30px;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
        }
        .success { 
            color: #4ade80; 
            font-weight: bold; 
            font-size: 1.2em;
            text-align: center;
            margin-bottom: 30px;
        }
        .info { 
            background: rgba(255,255,255,0.1); 
            padding: 25px; 
            border-radius: 10px; 
            margin: 20px 0;
            border-left: 4px solid #4ade80;
        }
        .info h3 {
            margin-top: 0;
            color: #4ade80;
        }
        .info ul {
            list-style: none;
            padding: 0;
        }
        .info li {
            padding: 8px 0;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .info li:last-child {
            border-bottom: none;
        }
        .info strong {
            color: #4ade80;
        }
        .footer {
            text-align: center;
            margin-top: 30px;
            font-style: italic;
            opacity: 0.8;
        }
        .badge {
            display: inline-block;
            background: #4ade80;
            color: #1f2937;
            padding: 5px 15px;
            border-radius: 20px;
            font-weight: bold;
            margin: 5px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🐍 Flask Application Deployed!</h1>
        <p class="success">Your Python Flask application has been successfully deployed using AWS CodeDeploy.</p>
        
        <div class="info">
            <h3>🚀 Application Information</h3>
            <ul>
                <li><strong>Framework:</strong> <span class="badge">Python Flask</span></li>
                <li><strong>Server:</strong> {{ hostname }}</li>
                <li><strong>Deployment Time:</strong> {{ deploy_time }}</li>
                <li><strong>Platform:</strong> Amazon Linux 2</li>
                <li><strong>Python Version:</strong> {{ python_version }}</li>
                <li><strong>Flask Version:</strong> {{ flask_version }}</li>
            </ul>
        </div>
        
        <div class="info">
            <h3>📊 Runtime Information</h3>
            <ul>
                <li><strong>Current Time:</strong> {{ current_time }}</li>
                <li><strong>Server IP:</strong> {{ server_ip }}</li>
                <li><strong>Process ID:</strong> {{ process_id }}</li>
                <li><strong>Working Directory:</strong> {{ working_dir }}</li>
            </ul>
        </div>
        
        <div class="footer">
            <p>🔄 This application was deployed through AWS CodeDeploy as part of your CI/CD pipeline.</p>
            <p>Visit <a href="/api/health" style="color: #4ade80;">/api/health</a> for health check endpoint</p>
        </div>
    </div>
</body>
</html>
'''

@app.route('/')
def home():
    try:
        import flask
        flask_version = flask.__version__
    except:
        flask_version = "Unknown"
    
    try:
        import sys
        python_version = f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}"
    except:
        python_version = "Unknown"
    
    return render_template_string(HTML_TEMPLATE,
        hostname=socket.gethostname(),
        deploy_time=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC"),
        current_time=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC"),
        server_ip=socket.gethostbyname(socket.gethostname()),
        process_id=os.getpid(),
        working_dir=os.getcwd(),
        python_version=python_version,
        flask_version=flask_version
    )

@app.route('/api/health')
def health_check():
    return {
        "status": "healthy",
        "timestamp": datetime.datetime.now().isoformat(),
        "hostname": socket.gethostname(),
        "version": "1.0.0"
    }

@app.route('/api/info')
def app_info():
    return {
        "application": "Flask Demo App",
        "version": "1.0.0",
        "python_version": f"{sys.version_info.major}.{sys.version_info.minor}.{sys.version_info.micro}",
        "hostname": socket.gethostname(),
        "timestamp": datetime.datetime.now().isoformat()
    }

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
