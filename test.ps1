# test.ps1 - Улучшенная версия
param(
    [string]$Url = "http://localhost:80",
    [int]$TimeoutSeconds = 10
)

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Running PowerShell integration tests" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

$allTestsPassed = $true

# Test 1: File exists
Write-Host "[TEST 1] Checking index.html file..." -ForegroundColor Yellow
if (Test-Path "index.html") {
    Write-Host "  ✓ PASS: index.html exists" -ForegroundColor Green
} else {
    Write-Host "  ✗ FAIL: index.html not found" -ForegroundColor Red
    $allTestsPassed = $false
}

# Test 2: Web server response
Write-Host "[TEST 2] Testing web server response..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri $Url -Method Get -UseBasicParsing -TimeoutSec $TimeoutSeconds
    if ($response.StatusCode -eq 200) {
        Write-Host "  ✓ PASS: HTTP $($response.StatusCode)" -ForegroundColor Green
        
        # Test 3: Content verification
        Write-Host "[TEST 3] Verifying content..." -ForegroundColor Yellow
        if ($response.Content -match "<h1>") {
            Write-Host "  ✓ PASS: HTML content contains h1 tag" -ForegroundColor Green
        } else {
            Write-Host "  ✗ FAIL: No h1 tag in response" -ForegroundColor Red
            $allTestsPassed = $false
        }
    } else {
        Write-Host "  ✗ FAIL: HTTP $($response.StatusCode)" -ForegroundColor Red
        $allTestsPassed = $false
    }
} catch {
    Write-Host "  ✗ FAIL: Cannot reach web server - $_" -ForegroundColor Red
    $allTestsPassed = $false
}

Write-Host "========================================" -ForegroundColor Cyan
if ($allTestsPassed) {
    Write-Host "ALL TESTS PASSED! ✓" -ForegroundColor Green
    exit 0
} else {
    Write-Host "SOME TESTS FAILED! ✗" -ForegroundColor Red
    exit 1
}