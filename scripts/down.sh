#!/usr/bin/env bash
set -euo pipefail

REMOVE_VOLUMES=0
for arg in "$@"; do
    case "$arg" in
        --volumes) REMOVE_VOLUMES=1 ;;
    esac
done

cd "$(dirname "$0")/../"

docker compose down -v

rm -rf ./config/homeassistant/custom_components/*

if [ "$REMOVE_VOLUMES" = 1 ]; then
    sudo rm -rf ./volumes/
fi