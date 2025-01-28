@echo off
docker-compose down -v

set BACKEND_REPO=https://github.com/BenGround/shared-house-app-back.git
set FRONTEND_REPO=https://github.com/BenGround/shared-house-app-frontend.git
set PROJECT_ROOT=%cd%

if exist %PROJECT_ROOT%\backend (
    echo Backend repository already exists, skipping clone...
    cd %PROJECT_ROOT%\backend
    git pull
    cd %PROJECT_ROOT%
) else (
    echo Cloning backend repository...
    git clone %BACKEND_REPO% %PROJECT_ROOT%\backend
)

if exist %PROJECT_ROOT%\frontend (
    cd %PROJECT_ROOT%\frontend
    git pull
    cd %PROJECT_ROOT%
) else (
    echo Cloning frontend repository...
    git clone %FRONTEND_REPO% %PROJECT_ROOT%\frontend
)

echo Creating .env file for frontend...

set FRONTEND_ENV_FILE=%PROJECT_ROOT%\frontend\.env
(
echo REACT_APP_API_URL=http://localhost:3000/
) > %FRONTEND_ENV_FILE%

cd %PROJECT_ROOT%

echo Building and running Docker containers...
docker-compose up -d --build

docker-compose exec backend npm run db:reseed

pause