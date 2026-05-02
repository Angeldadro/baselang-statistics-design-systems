# syntax=docker/dockerfile:1
FROM nginx:1.27-alpine

# Copy static files to nginx html directory
COPY . /usr/share/nginx/html

# Use custom nginx config
RUN rm -f /etc/nginx/conf.d/default.conf
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/health || exit 1

CMD ["nginx", "-g", "daemon off;"]