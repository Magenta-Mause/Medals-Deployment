FROM ecofreshkaese/medals-frontend:latest

COPY nginx/default.conf /etc/nginx/conf.d/default.conf

RUN chmod 644 /etc/nginx/conf.d/default.conf
