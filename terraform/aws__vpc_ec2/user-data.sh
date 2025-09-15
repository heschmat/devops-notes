#!/bin/bash
yum update -y
amazon-linux-extras enable nginx1
yum install -y nginx -y
systemctl enable nginx
systemctl start nginx

# Create custom index file
echo "Hello from TF via nginx on port 8080" | tee /usr/share/nginx/html/index.html

# Replace nginx.conf with minimal version that only loads our server block
cat > /etc/nginx/nginx.conf <<'EOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    access_log  /var/log/nginx/access.log;
    sendfile    on;
    keepalive_timeout 65;

    server {
        listen 8080;
        server_name _;
        root /usr/share/nginx/html;
        index index.html;
        location / {
            try_files $uri $uri/ =404;
        }
    }
}
EOF


# Restart nginx to apply the port change
systemctl restart nginx
