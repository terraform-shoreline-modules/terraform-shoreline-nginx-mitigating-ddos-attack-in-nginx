bash

#!/bin/bash



# Set the maximum time for a connection

timeout=${MAX_CONNECTION_TIME}



# Backup the current configuration file

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak



# Edit the configuration file to set the timeout value

sed -i "s|keepalive_timeout\s*.*|keepalive_timeout $timeout;|" /etc/nginx/nginx.conf



# Test the configuration

nginx -t



# Reload the NGINX service to apply the changes

systemctl reload nginx.service