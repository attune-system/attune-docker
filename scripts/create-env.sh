#!/usr/bin/env sh

set -eu

if [ -e .env ]; then
    echo ".env already exists; refusing to overwrite it." >&2
    exit 1
fi

umask 077

cat >.env <<EOF
ATTUNE_IMAGE_REGISTRY=ghcr.io/attune-system
ATTUNE_IMAGE_TAG=edge
JWT_SECRET=$(openssl rand -hex 32)
ENCRYPTION_KEY=$(openssl rand -hex 32)
AGENT_BOOTSTRAP_TOKEN=$(openssl rand -hex 32)
ATTUNE_TEST_LOGIN=test@attune.local
ATTUNE_TEST_PASSWORD=TestPass123!
ATTUNE_TEST_DISPLAY_NAME=Test User
API_URL=http://localhost:8080
WS_URL=ws://localhost:8081
EOF

echo "Created .env with generated secrets."
