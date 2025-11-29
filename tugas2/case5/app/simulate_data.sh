#!/usr/bin/env bash

id=$1
sleep 2 # simulate latency (2 seconds)
cat <<EOF
{"id":"${id}","value":"This is simulated data for id ${id}","generated_at":"$(date --iso-8601=seconds)"}
EOF
