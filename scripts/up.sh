#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../"

mkdir -p ./volumes/homeassistant/config/.storage
cp ./config/homeassistant/.storage/onboarding ./volumes/homeassistant/config/.storage/onboarding

wget -O /tmp/meross.zip https://github.com/albertogeniola/meross-homeassistant/archive/refs/tags/v1.3.12.zip
unzip -d /tmp/meross /tmp/meross.zip
mv /tmp/meross/meross-homeassistant-1.3.12/custom_components/meross_cloud ./config/homeassistant/custom_components/meross_cloud

docker compose up -d --wait
curl --location --request POST 'http://127.0.0.1:8123/api/onboarding/users' \
    --header 'Content-Type: application/json' \
    --data-raw '{
        "client_id": "http://127.0.0.1:8123/",
        "name": "admin",
        "username": "admin",
        "password": "12345",
        "language": "en"
    }'
