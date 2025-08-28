#!/bin/bash

# Deploy script for learn-stack
# Usage: ./scripts/deploy.sh [dev|prod]

set -e

ENVIRONMENT=${1:-dev}
COMPOSE_BASE="compose.yml"
COMPOSE_OVERRIDE="compose.${ENVIRONMENT}.yml"

echo "🚀 Deploying learn-stack in ${ENVIRONMENT} mode..."

# Check if override file exists
if [ -f "$COMPOSE_OVERRIDE" ]; then
    echo "❌ Override file $COMPOSE_OVERRIDE not found!"
    exit 1
fi

# Load environment variables
if [ -f ".env" ]; then
    echo "📋 Loading environment variables from .env"
    export $(cat .env | grep -v '^#' | xargs)
fi

# Validate configuration
echo "🔍 Validating Docker Compose configuration..."
docker compose -f "$COMPOSE_BASE" -f "$COMPOSE_OVERRIDE" config > /dev/null
echo "✅ Configuration is valid"

# Build and deploy
echo "🏗️  Building and starting services..."
docker compose -f "$COMPOSE_BASE" -f "$COMPOSE_OVERRIDE" up -d --build

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check service status
echo "📊 Service status:"
docker compose -f "$COMPOSE_BASE" -f "$COMPOSE_OVERRIDE" ps

# Health checks
echo "🏥 Running health checks..."
if [ "$ENVIRONMENT" = "prod" ]; then
    # Production health checks
    if [ -n "$PROD_DOMAIN" ]; then
        echo "Testing production endpoints..."
        curl -f "http://$PROD_DOMAIN/health" || echo "❌ Health check failed"
    fi
else
    # Development health checks
    echo "Testing development endpoints..."
    curl -f "http://localhost/health" || echo "❌ Health check failed"
fi

echo "🎉 Deployment completed successfully!"
