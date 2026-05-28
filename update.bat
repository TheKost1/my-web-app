@echo off
setlocal enabledelayedexpansion

echo ========================================
echo Starting deployment process...
echo ========================================

set DEPLOY_DIR=C:\nginx\html\index
set BACKUP_DIR=C:\nginx\html\index_backup

cd /d %DEPLOY_DIR%

echo [STEP 1] Creating backup...
if exist %BACKUP_DIR% rmdir /s /q %BACKUP_DIR%
mkdir %BACKUP_DIR%
xcopy /E /I %DEPLOY_DIR%\* %BACKUP_DIR% > nul
echo Backup created successfully

echo [STEP 2] Pulling latest code...
git pull origin main
if errorlevel 1 (
    echo ERROR: Git pull failed
    goto rollback
)

echo [STEP 3] Running tests...
call test.bat
if errorlevel 1 (
    echo ERROR: Tests failed
    goto rollback
)

echo [STEP 4] Tests passed, deploying...
echo Reloading nginx...
nginx -s reload
if errorlevel 1 (
    echo WARNING: nginx reload returned error
) else (
    echo nginx reloaded successfully
)

echo ========================================
echo DEPLOYMENT COMPLETED SUCCESSFULLY!
echo ========================================
exit /b 0

:rollback
echo ========================================
echo ROLLBACK INITIATED
echo ========================================
if exist %BACKUP_DIR% (
    echo Restoring from backup...
    xcopy /E /I /Y %BACKUP_DIR%\* %DEPLOY_DIR% > nul
    rmdir /s /q %BACKUP_DIR%
    echo Backup restored
    echo Reloading nginx...
    nginx -s reload
    echo Rollback completed
) else (
    echo ERROR: No backup found!
)
exit /b 1