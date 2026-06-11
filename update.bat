@echo off
cd C:\nginx\html\index
git pull origin main
test.bat
if %errorlevel% equ 0 (
    echo Tests passed, reloading web server
    nginx -s reload
) else (
    echo Tests failed, rollback
    git reset --hard HEAD^
)