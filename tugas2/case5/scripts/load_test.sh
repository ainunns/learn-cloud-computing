#!/usr/bin/env bash

URL="http://localhost:5000/item/123"
COUNT=${1:-10}

echo "Sending $COUNT requests..."

for i in $(seq 1 $COUNT); do
  curl -s $URL >/dev/null
done

echo "Done."
curl -s http://localhost:5000/cache/stats | jq .
