#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../"

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
