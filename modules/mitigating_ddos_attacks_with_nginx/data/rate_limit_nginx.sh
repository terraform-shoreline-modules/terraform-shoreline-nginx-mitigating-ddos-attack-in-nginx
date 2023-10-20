

#!/bin/bash



# Set the maximum number of requests per second

MAX_REQUESTS_PER_SECOND=${MAX_REQUESTS_PER_SECOND}



# Set the burst size to allow temporary spikes in traffic

BURST_SIZE=${BURST_SIZE}



# Backup the current configuration file

cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak



# Edit the NGINX configuration file to limit the rate of requests

sudo sed -i 's/#\?limit_req_zone.*/limit_req_zone $binary_remote_addr zone=req_limit_per_ip:${MEMORY_SIZE}m rate=${MAX_REQUESTS_PER_SECOND}r/s' /etc/nginx/nginx.conf



sudo sed -i 's/#\?limit_req.*/limit_req zone=req_limit_per_ip burst=${BURST_SIZE} nodelay;/s' /etc/nginx/nginx.conf



# test the configuration

nginx -t



# Restart NGINX to apply the changes

sudo systemctl restart nginx