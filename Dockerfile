FROM nginx:1.27-alpine
RUN mkdir -p /var/log/sdds     && sed -i 's/listen       80;/listen       8080;/' /etc/nginx/conf.d/default.conf     && echo "SDDS placeholder application" > /usr/share/nginx/html/index.html
EXPOSE 8080
