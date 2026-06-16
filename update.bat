@echo off
set REPO_PATH=C:\nginx\html\index
set DEPLOY_PATH=C:\Lab1

echo === Updating repository ===
cd /d %REPO_PATH%
git pull origin main

if %errorlevel% neq 0 (
    echo Git pull failed, aborting
    exit /b 1
)

echo === Running tests ===
call test.bat
if %errorlevel% neq 0 (
    echo Tests failed, rolling back...
    git reset --hard HEAD^
    exit /b 1
)

echo === Deploying to %DEPLOY_PATH% ===
if not exist "%DEPLOY_PATH%" mkdir "%DEPLOY_PATH%"
xcopy /E /Y "%REPO_PATH%\*" "%DEPLOY_PATH%\" > nul

echo === Reloading nginx ===
nginx -s reload

echo === Deployment completed successfully ===
exit /b 0