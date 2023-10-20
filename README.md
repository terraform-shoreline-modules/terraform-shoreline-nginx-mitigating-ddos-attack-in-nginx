
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Mitigating DDoS Attacks with NGINX
---

This incident type is related to mitigating Distributed Denial of Service (DDoS) attacks using NGINX, which is a popular web server software. DDoS attacks involve overwhelming a server with a flood of traffic from multiple sources, resulting in a denial of service for legitimate users. To prevent such attacks, various techniques can be used such as limiting the rate of requests, number of connections, blocking requests, and using caching to smooth traffic spikes. NGINX can be configured to implement these techniques and provide protection against DDoS attacks.

### Parameters
```shell
export PORT_NUMBER="PLACEHOLDER"

export INTERFACE_NAME="PLACEHOLDER"

export BURST_SIZE="PLACEHOLDER"

export MAX_REQUESTS_PER_SECOND="PLACEHOLDER"

export MAX_CONNECTION_TIME="PLACEHOLDER"

export MAX_CONNECTIONS_PER_IP="PLACEHOLDER"
```

## Debug

### Check if NGINX is running
```shell
systemctl status nginx
```

### Check the current configuration of NGINX
```shell
nginx -t
```

### Check the access and error logs of NGINX
```shell
tail -f /var/log/nginx/access.log

tail -f /var/log/nginx/error.log
```

### Check the network traffic to the server using the tcpdump command
```shell
tcpdump -i ${INTERFACE_NAME} port ${PORT_NUMBER}
```

### Check the number of active connections to the server
```shell
netstat -an | grep :${PORT_NUMBER} | wc -l
```

### Check the number of connections per IP address
```shell
netstat -an | grep :${PORT_NUMBER} | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | sort -n
```

### Check the NGINX cache status
```shell
nginx -V 2>&1 | grep -o with-http_stub_status_module

curl http://localhost/nginx_status
```

### Check the NGINX configuration for rate limiting
```shell
grep -R "limit_req_zone" /etc/nginx/
```

### Check the NGINX configuration for connection limiting
```shell
grep -R "limit_conn_zone" /etc/nginx/
```

## Repair

### Configure NGINX to limit the rate of requests to the server, so that it can handle traffic spikes without being overwhelmed.
```shell


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


```

### Limiting the Number of Connections that can be opened by a single client IP address,
```shell


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


```

### Close slow connections to free up server resources for legitimate users.
```shell
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


```