

#!/bin/bash



# Set the variables

MAX_CONN_PER_IP=${MAX_CONNECTIONS_PER_IP}



# Backup the current configuration file

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak



# Edit the nginx.conf file to limit the number of connections per IP address

sudo sed -i "s/# limit_conn_zone.*/limit_conn_zone \$binary_remote_addr zone=conn_limit_per_ip:${MAX_CONN_PER_IP};/" /etc/nginx/nginx.conf

sudo sed -i "s/# limit_conn.*/limit_conn conn_limit_per_ip ${MAX_CONN_PER_IP};/" /etc/nginx/nginx.conf



# Test the configuration

nginx -t



# Restart the nginx service to apply the changes

sudo systemctl restart nginx