@echo off
cd C:\Users\Admin\source\repos\semenar6\AdminIS\my-web-app
git pull origin main
test.bat
if %errorlevel% equ 0 (
    echo Tests passed, reloading web server
    nginx -s reload
) else (
    echo Tests failed, rollback
    git reset --hard HEAD^
)