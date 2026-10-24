#!/usr/bin/env bash
# Builds and serves the app twice (streaming on, then off) and prints the cache headers.
set -e
cd "$(dirname "$0")"
NODE=${NODE:-node}
run() {
  echo "=== $1 ==="
  env $2 "$NODE" node_modules/.bin/astro build >/dev/null
  PORT=4399 "$NODE" dist/server/entry.mjs >server.log 2>&1 &
  pid=$!
  sleep 2
  curl -sI http://localhost:4399/ | grep -i -E '^(cache-tag|cdn-cache-control)'
  grep '\[layout\]' server.log || true
  kill $pid; wait $pid 2>/dev/null || true
  echo
}
run "streaming ON (default)" ""
run "streaming OFF (experimentalDisableStreaming)" "NO_STREAM=1"
