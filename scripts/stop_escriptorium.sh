#!/usr/bin/env bash
set -euo pipefail

ESCRIPTORIUM_DIR="${HOME}/tools/escriptorium"
if [[ ! -d "$ESCRIPTORIUM_DIR" ]]; then
  echo "eScriptorium is not installed at $ESCRIPTORIUM_DIR" >&2
  exit 1
fi
if [[ ! -f "$ESCRIPTORIUM_DIR/docker-compose.yml" || ! -f "$ESCRIPTORIUM_DIR/variables.env" ]]; then
  echo "eScriptorium is not configured. See Session_04/README.md." >&2
  exit 1
fi

docker compose -f "$ESCRIPTORIUM_DIR/docker-compose.yml" \
  --env-file "$ESCRIPTORIUM_DIR/variables.env" \
  down
