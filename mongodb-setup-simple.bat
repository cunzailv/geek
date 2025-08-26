@echo off
echo MongoDB Setup and Check Script
echo ================================

echo.
echo Checking if MongoDB is installed...
where mongod >nul 2>&1
if %errorlevel% == 0 (
    echo MongoDB is already installed!
    mongod --version
    goto :start_mongodb
) else (
    echo MongoDB is not installed.
    goto :install_guide
)

:install_guide
echo.
echo MongoDB Installation Guide:
echo 1. Visit: https://www.mongodb.com/try/download/community
echo 2. Download Windows MSI installer
echo 3. Run installer and select Complete installation
echo 4. Check "Install MongoDB as a Service"
echo 5. Restart this script after installation
echo.
echo Press any key to open download page...
pause >nul
start https://www.mongodb.com/try/download/community
echo.
echo After installation, press any key to continue...
pause >nul
goto :check_again

:check_again
where mongod >nul 2>&1
if %errorlevel% == 0 (
    echo MongoDB installation detected!
    goto :start_mongodb
) else (
    echo MongoDB still not found. Please check installation.
    pause
    exit /b 1
)

:start_mongodb
echo.
echo Creating data directories...
if not exist "C:\data\db" mkdir "C:\data\db"
if not exist "C:\data\log" mkdir "C:\data\log"

echo.
echo Starting MongoDB service...
net start MongoDB >nul 2>&1
if %errorlevel% == 0 (
    echo MongoDB service started successfully!
) else (
    echo Starting MongoDB manually...
    start "MongoDB" mongod --dbpath "C:\data\db"
    timeout /t 5 >nul
)

echo.
echo Testing MongoDB connection...
timeout /t 3 >nul
mongo --eval "db.adminCommand('ismaster')" >nul 2>&1
if %errorlevel% == 0 (
    echo MongoDB connection successful!
    goto :init_db
) else (
    echo MongoDB connection failed.
    echo Please check if MongoDB is running.
    pause
    exit /b 1
)

:init_db
echo.
echo Initializing database...
if exist "init-db.js" (
    mongo navigation < init-db.js
    echo Database initialization completed!
) else (
    echo init-db.js not found. Skipping database initialization.
)

echo.
echo MongoDB setup completed!
echo.
echo Next steps:
echo 1. Run start-dev.bat to start all services
echo 2. Access frontend at http://localhost:3000
echo 3. Access admin panel at http://localhost:8000
echo.
pause