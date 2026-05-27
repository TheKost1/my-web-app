# test.ps1
try {
    $response = Invoke-WebRequest -Uri "http://localhost:80" -Method Get -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "Test passed"
        exit 0
    } else {
        Write-Host "Test failed"
        exit 1
    }
} catch {
    Write-Host "Test failed"
    exit 1
}