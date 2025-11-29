#!/usr/bin/env bash

URL="http://localhost:5000/item/123"

echo "First call (expect ~2s and source=origin):"
time curl -s $URL | jq .

echo
echo "Second call (expect fast and source=cache):"
time curl -s $URL | jq .

echo
echo "Cache stats:"
curl -s http://localhost:5000/cache/stats | jq .
