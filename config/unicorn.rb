upstream app {
    # Path to Unicorn SOCK file, as defined previously
    server unix:/home/deploy/portfolio/shared/sockets/unicorn.sock fail_timeout=0;
}
server {
    listen 80;
    server_name localhost;
root /home/deploy/appname/public;
try_files $uri/index.html $uri @app;
location @app {
        proxy_pass http://app;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
    }
error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}
