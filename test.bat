@echo off
echo ========================================
echo Running comprehensive tests...
echo ========================================

set FAILED=0

echo [TEST 1] Checking index.html exists...
if not exist index.html (
    echo [FAIL] index.html missing
    set FAILED=1
) else (
    echo [PASS] index.html exists
)

echo [TEST 2] Validating HTML content...
findstr /C:"<h1>" index.html > nul
if errorlevel 1 (
    echo [FAIL] No h1 tag found
    set FAILED=1
) else (
    echo [PASS] h1 tag present
)

echo [TEST 3] Checking version format...
findstr /C:"Version:" index.html > nul
if errorlevel 1 (
    echo [WARN] Version info not found
) else (
    echo [PASS] Version info present
)

echo ========================================
if %FAILED% equ 0 (
    echo ALL TESTS PASSED!
    exit /b 0
) else (
    echo TESTS FAILED!
    exit /b 1
)