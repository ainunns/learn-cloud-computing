#!/usr/bin/env bash
set -euo pipefail

NETWORK="case4_net"

APP_V1="v1_app"
APP_V2="v2_app"
NGINX="nginx_canary"

docker network create $NETWORK 2>/dev/null || true

docker rm -f $APP_V1 $APP_V2 $NGINX >/dev/null 2>&1 || true

docker run -dit --name $APP_V1 \
  --network $NETWORK \
  -w /app \
  -v "$(pwd)/server/app-v1.py":/app/server.py:ro \
  -v "$(pwd)/files":/usr/share/app:ro \
  -e HOSTNAME=$APP_V1 \
  python:3.11-slim \
  /bin/sh -c "python server.py"

docker run -dit --name $APP_V2 \
  --network $NETWORK \
  -w /app \
  -v "$(pwd)/server/app-v2.py":/app/server.py:ro \
  -v "$(pwd)/files":/usr/share/app:ro \
  -e HOSTNAME=$APP_V2 \
  python:3.11-slim \
  /bin/sh -c "python server.py"

docker run -dit --name $NGINX \
  --network $NETWORK \
  -p 8081:80 \
  -v "$(pwd)/nginx/nginx.conf":/etc/nginx/nginx.conf:ro nginx:alpine
