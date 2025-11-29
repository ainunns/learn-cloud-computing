import os
import time
import json
import subprocess
from flask import Flask, jsonify
import redis

REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = int(os.getenv("REDIS_PORT", 6379))
CACHE_TTL = int(os.getenv("CACHE_TTL", 30))  # seconds

r = redis.Redis(host=REDIS_HOST, port=REDIS_PORT, db=0, decode_responses=True)
app = Flask(__name__)

def fetch_slow_data(item_id: str):
    # simulate slow fetch by calling script (or you could implement direct sleep)
    result = subprocess.run(["/app/simulate_data.sh", item_id], capture_output=True, text=True)
    return json.loads(result.stdout)

@app.route("/item/<item_id>")
def get_item(item_id):
    cache_key = f"item:{item_id}"
    cached = r.get(cache_key)
    if cached:
        app.logger.info(f"Cache HIT for {cache_key}")
        resp = json.loads(cached)
        resp["_source"] = "cache"
        return jsonify(resp)

    app.logger.info(f"Cache MISS for {cache_key} - fetching slow data")
    data = fetch_slow_data(item_id)
    data["_source"] = "origin"
    r.setex(cache_key, CACHE_TTL, json.dumps(data))
    return jsonify(data)

@app.route("/cache/clear/<item_id>")
def clear_cache(item_id):
    key = f"item:{item_id}"
    removed = r.delete(key)
    return jsonify({"deleted": bool(removed), "key": key})

@app.route("/cache/stats")
def cache_stats():
    info = r.info()
    return jsonify({
        "used_memory_human": info.get("used_memory_human"),
        "keyspace_hits": info.get("keyspace_hits"),
        "keyspace_misses": info.get("keyspace_misses"),
        "db0_keys": info.get("db0", {})
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)

