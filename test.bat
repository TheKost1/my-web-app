@echo off
echo Running tests...
if not exist index.html (
    echo FAIL: index.html missing
    exit /b 1
)
echo PASS: index.html exists
exit /b 0