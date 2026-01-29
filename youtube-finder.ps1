# Quick YouTube Content Finder
# Simpler version - just give topics, get recommendations

param(
    [string]$Topic = ""
)

Write-Host "`n🎥 YouTube Content Finder (AI-Powered)" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor Cyan

if ($Topic -eq "") {
    $Topic = Read-Host "`nWhat topic are you interested in?"
}

Write-Host "`nSearching for: $Topic" -ForegroundColor Yellow
Write-Host "Consulting AI..." -ForegroundColor Gray
Write-Host ""

# Ask Moltbot
$query = "Recommend 5 great YouTube channels and 3 must-watch videos about: $Topic. Include brief descriptions."

$result = clawdbot agent --to +1234567890 --message $query --local 2>&1

Write-Host "=====================================" -ForegroundColor Green
Write-Host "📺 RECOMMENDATIONS:" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host $result
Write-Host ""

# Option to open YouTube
$open = Read-Host "`nOpen YouTube to search? (y/n)"
if ($open -eq "y") {
    $searchUrl = "https://www.youtube.com/results?search_query=$($Topic -replace ' ','+')"
    Start-Process $searchUrl
    Write-Host "✅ Opened YouTube search for: $Topic" -ForegroundColor Green
}
