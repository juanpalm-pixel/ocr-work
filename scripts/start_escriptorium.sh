#!/usr/bin/env bash
set -euo pipefail

ESCRIPTORIUM_DIR="${HOME}/tools/escriptorium"
if [[ ! -d "$ESCRIPTORIUM_DIR" ]]; then
  echo "eScriptorium is not installed at $ESCRIPTORIUM_DIR" >&2
  exit 1
fi
if [[ ! -f "$ESCRIPTORIUM_DIR/docker-compose.yml" || ! -f "$ESCRIPTORIUM_DIR/variables.env" ]]; then
  echo "eScriptorium is not configured. Clone the upstream repository and create variables.env first; see Session_04/README.md." >&2
  exit 1
fi
if ! docker info >/dev/null 2>&1; then
  echo "Docker is unavailable. Enable Ubuntu in Docker Desktop's WSL Integration settings, then retry." >&2
  exit 1
fi

docker compose -f "$ESCRIPTORIUM_DIR/docker-compose.yml" \
  --env-file "$ESCRIPTORIUM_DIR/variables.env" \
  up -d
docker compose -f "$ESCRIPTORIUM_DIR/docker-compose.yml" \
  --env-file "$ESCRIPTORIUM_DIR/variables.env" ps
echo "Open http://localhost:8080"
