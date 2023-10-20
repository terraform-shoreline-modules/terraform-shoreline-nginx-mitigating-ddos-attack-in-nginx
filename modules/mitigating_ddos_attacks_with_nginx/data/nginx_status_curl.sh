nginx -V 2>&1 | grep -o with-http_stub_status_module

curl http://localhost/nginx_status