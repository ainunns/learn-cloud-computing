#!/usr/bin/env bash

URL="http://localhost:8081/info"
REQUESTS=30

count_v1=0
count_v2=0

random_ip() {
  echo "$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255)).$((RANDOM % 255))"
}

for i in $(seq 1 $REQUESTS); do
  IP=$(random_ip)

  # Capture backend response (must be exactly "v1" or "v2")
  RESP=$(curl -s -H "X-Forwarded-For: $IP" "$URL")

  if [[ "$RESP" == *"v1"* ]]; then
    ((count_v1++))
  elif [[ "$RESP" == *"v2"* ]]; then
    ((count_v2++))
  fi

  echo "[$i] $IP → $RESP"
done

echo
echo "===== SUMMARY ====="
echo "v1: $count_v1 requests"
echo "v2: $count_v2 requests"
