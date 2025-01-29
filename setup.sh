#!/bin/bash

BACKEND_REPO="https://github.com/BenGround/shared-house-app-back.git"
FRONTEND_REPO="https://github.com/BenGround/shared-house-app-frontend.git"
PROJECT_ROOT=$(pwd)

if [ -d "$PROJECT_ROOT/backend" ]; then
    echo "Backend repository already exists, skipping clone..."
    cd "$PROJECT_ROOT/backend"
    git pull
    cd "$PROJECT_ROOT"
else
    echo "Cloning backend repository..."
    git clone "$BACKEND_REPO" "$PROJECT_ROOT/backend"
fi

if [ -d "$PROJECT_ROOT/frontend" ]; then
    cd "$PROJECT_ROOT/frontend"
    git pull
    cd "$PROJECT_ROOT"
else
    echo "Cloning frontend repository..."
    git clone "$FRONTEND_REPO" "$PROJECT_ROOT/frontend"
fi

echo "Creating .env file for frontend..."

FRONTEND_ENV_FILE="$PROJECT_ROOT/frontend/.env"

echo "REACT_APP_API_URL=http://localhost:3000/" > "$FRONTEND_ENV_FILE"
echo "NODE_ENV=production" >> "$FRONTEND_ENV_FILE"

echo "Building and running Docker containers..."
DOCKER_BUILDKIT=1 docker-compose up -d --build

echo "Project setup complete!"