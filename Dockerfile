# syntax=docker/dockerfile:1
FROM nginx:1.27-alpine

# Copy static files
COPY . /usr/share/nginx/html

# Write nginx config inline so it's baked into the image
RUN echo 'server {' \
    '    listen 80 default_server;' \
    '    server_name _;' \
    '    root /usr/share/nginx/html;' \
    '    index index.html;' \
    '    add_header X-Frame-Options "SAMEORIGIN" always;' \
    '    add_header X-Content-Type-Options "nosniff" always;' \
    '    add_header X-XSS-Protection "1; mode=block" always;' \
    '    location ~* \.(?:css|js|jpg|jpeg|png|gif|ico|svg|woff|woff2|ttf|eot)$ { expires 1y; add_header Cache-Control "public, immutable"; access_log off; }' \
    '    gzip on; gzip_vary on; gzip_proxied any; gzip_comp_level 6; gzip_min_length 1024; gzip_types text/plain text/css text/xml text/javascript application/javascript application/json application/xml;' \
    '    location / { try_files $uri $uri/ /index.html; }' \
    '    location /health { access_log off; return 200 "ok\n"; add_header Content-Type text/plain; }' \
    '    access_log /var/log/nginx/access.log;' \
    '    error_log /var/log/nginx/error.log warn;' \
    '}' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]