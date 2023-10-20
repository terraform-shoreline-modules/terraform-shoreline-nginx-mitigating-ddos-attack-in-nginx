resource "shoreline_notebook" "mitigating_ddos_attacks_with_nginx" {
  name       = "mitigating_ddos_attacks_with_nginx"
  data       = file("${path.module}/data/mitigating_ddos_attacks_with_nginx.json")
  depends_on = [shoreline_action.invoke_nginx_logs,shoreline_action.invoke_nginx_status_curl,shoreline_action.invoke_rate_limit_nginx,shoreline_action.invoke_nginx_connection_limit,shoreline_action.invoke_nginx_timeout_config]
}

resource "shoreline_file" "nginx_logs" {
  name             = "nginx_logs"
  input_file       = "${path.module}/data/nginx_logs.sh"
  md5              = filemd5("${path.module}/data/nginx_logs.sh")
  description      = "Check the access and error logs of NGINX"
  destination_path = "/tmp/nginx_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "nginx_status_curl" {
  name             = "nginx_status_curl"
  input_file       = "${path.module}/data/nginx_status_curl.sh"
  md5              = filemd5("${path.module}/data/nginx_status_curl.sh")
  description      = "Check the NGINX cache status"
  destination_path = "/tmp/nginx_status_curl.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "rate_limit_nginx" {
  name             = "rate_limit_nginx"
  input_file       = "${path.module}/data/rate_limit_nginx.sh"
  md5              = filemd5("${path.module}/data/rate_limit_nginx.sh")
  description      = "Configure NGINX to limit the rate of requests to the server, so that it can handle traffic spikes without being overwhelmed."
  destination_path = "/tmp/rate_limit_nginx.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "nginx_connection_limit" {
  name             = "nginx_connection_limit"
  input_file       = "${path.module}/data/nginx_connection_limit.sh"
  md5              = filemd5("${path.module}/data/nginx_connection_limit.sh")
  description      = "Limiting the Number of Connections that can be opened by a single client IP address,"
  destination_path = "/tmp/nginx_connection_limit.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "nginx_timeout_config" {
  name             = "nginx_timeout_config"
  input_file       = "${path.module}/data/nginx_timeout_config.sh"
  md5              = filemd5("${path.module}/data/nginx_timeout_config.sh")
  description      = "Close slow connections to free up server resources for legitimate users."
  destination_path = "/tmp/nginx_timeout_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_nginx_logs" {
  name        = "invoke_nginx_logs"
  description = "Check the access and error logs of NGINX"
  command     = "`chmod +x /tmp/nginx_logs.sh && /tmp/nginx_logs.sh`"
  params      = []
  file_deps   = ["nginx_logs"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_logs]
}

resource "shoreline_action" "invoke_nginx_status_curl" {
  name        = "invoke_nginx_status_curl"
  description = "Check the NGINX cache status"
  command     = "`chmod +x /tmp/nginx_status_curl.sh && /tmp/nginx_status_curl.sh`"
  params      = []
  file_deps   = ["nginx_status_curl"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_status_curl]
}

resource "shoreline_action" "invoke_rate_limit_nginx" {
  name        = "invoke_rate_limit_nginx"
  description = "Configure NGINX to limit the rate of requests to the server, so that it can handle traffic spikes without being overwhelmed."
  command     = "`chmod +x /tmp/rate_limit_nginx.sh && /tmp/rate_limit_nginx.sh`"
  params      = ["BURST_SIZE","MAX_REQUESTS_PER_SECOND"]
  file_deps   = ["rate_limit_nginx"]
  enabled     = true
  depends_on  = [shoreline_file.rate_limit_nginx]
}

resource "shoreline_action" "invoke_nginx_connection_limit" {
  name        = "invoke_nginx_connection_limit"
  description = "Limiting the Number of Connections that can be opened by a single client IP address,"
  command     = "`chmod +x /tmp/nginx_connection_limit.sh && /tmp/nginx_connection_limit.sh`"
  params      = ["MAX_CONNECTIONS_PER_IP"]
  file_deps   = ["nginx_connection_limit"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_connection_limit]
}

resource "shoreline_action" "invoke_nginx_timeout_config" {
  name        = "invoke_nginx_timeout_config"
  description = "Close slow connections to free up server resources for legitimate users."
  command     = "`chmod +x /tmp/nginx_timeout_config.sh && /tmp/nginx_timeout_config.sh`"
  params      = ["MAX_CONNECTION_TIME"]
  file_deps   = ["nginx_timeout_config"]
  enabled     = true
  depends_on  = [shoreline_file.nginx_timeout_config]
}

