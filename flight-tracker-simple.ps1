# Simple Flight Tracker - Works without web search
param(
    [string]$Route = "USA to India"
)

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host " FLIGHT TRACKER - $Route" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

$query = "Based on typical travel patterns, give me practical advice for flights from $Route. Include: 1) Best 3 booking websites, 2) Typical price range, 3) Cheapest months, 4) Best airlines, 5) Key booking tips. Be brief and specific. Use only your training knowledge."

Write-Host "Querying AI..." -ForegroundColor Yellow

$result = clawdbot agent --to +1234567890 --message $query --local 2>&1 | Out-String

Write-Host ""
Write-Host "RESULTS:" -ForegroundColor Green
Write-Host "--------" -ForegroundColor Green
Write-Host $result

# Save
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$output = @"
FLIGHT TRACKER REPORT
Route: $Route
Time: $timestamp

$result
"@

$output | Out-File -FilePath "flight-info.txt" -Encoding UTF8

Write-Host ""
Write-Host "Saved to: flight-info.txt" -ForegroundColor Cyan
Write-Host ""
