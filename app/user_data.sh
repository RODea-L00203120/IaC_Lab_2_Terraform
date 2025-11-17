#!/bin/bash
set -e

exec > /var/log/user-data.log 2>&1

yum update -y
yum install -y python3 python3-pip nginx

mkdir -p /opt/flask-app
cd /opt/flask-app

cat > app.py <<'PYTHON'
${flask_app_code}
PYTHON

mkdir -p /opt/flask-app/templates

cat > /opt/flask-app/templates/index.html <<'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Employee Feedback App</title>
</head>
<body>
    <h1>Hello from {{ hostname }}</h1>
    <p>Flask application running successfully!</p>
    <p>Server: {{ hostname }}</p>
</body>
</html>
HTML

pip3 install flask gunicorn

cat > /etc/nginx/conf.d/flask.conf <<'NGINX'
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
NGINX

rm -f /etc/nginx/nginx.conf.default

systemctl start nginx
systemctl enable nginx

cd /opt/flask-app
nohup gunicorn -w 2 -b 0.0.0.0:5000 app:app > /var/log/flask.log 2>&1 &