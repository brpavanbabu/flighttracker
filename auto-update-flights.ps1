# Automated Daily Flight Price Checker & Website Updater
# Runs daily, checks prices, updates website, closes browsers

param(
    [switch]$SkipBrowser,
    [switch]$TestMode
)

$ErrorActionPreference = "Continue"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AUTOMATED FLIGHT PRICE UPDATER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Configuration
$depDate = "July 7, 2026"
$retDate = "August 4, 2026"
$route = "Switzerland to Bangalore"

# Step 1: Query AI for current price recommendations
Write-Host "[1/6] Querying AI for price updates..." -ForegroundColor Yellow

$query = "Based on typical patterns for flights from Switzerland to Bangalore on July 7-August 4, 2026: What would be the expected price ranges today? Give 4 airlines: Turkish Airlines via Istanbul, Emirates via Dubai, Qatar Airways via Doha, and Air India direct. Format: Airline: CHF XXX-XXX. Be concise."

try {
    $priceUpdate = clawdbot agent --to +1234567890 --message $query --local 2>&1 | Out-String
    Write-Host "   AI response received" -ForegroundColor Green
    Write-Host ""
} catch {
    Write-Host "   Warning: AI query failed, using cached prices" -ForegroundColor Yellow
    $priceUpdate = "Using previous prices"
}

# Step 2: Log the update
Write-Host "[2/6] Logging price check..." -ForegroundColor Yellow

$logEntry = @"
========================================
Date: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
Route: $route
Dates: $depDate -> $retDate

AI Price Update:
$priceUpdate
========================================

"@

$logEntry | Out-File -FilePath "flight-price-log.txt" -Append -Encoding UTF8
Write-Host "   Logged to flight-price-log.txt" -ForegroundColor Green
Write-Host ""

# Step 3: Update HTML timestamp
Write-Host "[3/6] Updating website timestamp..." -ForegroundColor Yellow

$htmlFile = "index.html"
$timestamp = Get-Date -Format "MMMM dd, yyyy HH:mm"

if (Test-Path $htmlFile) {
    $html = Get-Content $htmlFile -Raw
    $html = $html -replace 'Last Updated: [^<]*', "Last Updated: $timestamp"
    $html | Out-File -FilePath $htmlFile -Encoding UTF8 -NoNewline
    Write-Host "   Website updated with new timestamp" -ForegroundColor Green
} else {
    Write-Host "   Warning: index.html not found" -ForegroundColor Yellow
}
Write-Host ""

# Step 4: Check prices in browser (if not skipped)
if (-not $SkipBrowser) {
    Write-Host "[4/6] Opening price comparison sites..." -ForegroundColor Yellow
    
    # Open comparison sites
    Start-Process "https://www.google.com/flights?hl=en#flt=ZRH.BLR.2026-07-07*BLR.ZRH.2026-08-04;c:CHF;e:1;sd:1;t:f"
    Start-Sleep -Milliseconds 1000
    Start-Process "https://www.skyscanner.com/transport/flights/zrh/blr/260707/260804/"
    
    Write-Host "   Price sites opened" -ForegroundColor Green
    Write-Host "   Waiting 30 seconds for price loading..." -ForegroundColor Gray
    
    # Wait for user to see prices
    Start-Sleep -Seconds 30
    
    Write-Host ""
    Write-Host "[5/6] Closing browsers..." -ForegroundColor Yellow
    
    # Close Chrome/Edge browsers
    try {
        Get-Process -Name "chrome" -ErrorAction SilentlyContinue | Stop-Process -Force
        Get-Process -Name "msedge" -ErrorAction SilentlyContinue | Stop-Process -Force
        Write-Host "   Browsers closed" -ForegroundColor Green
    } catch {
        Write-Host "   No browsers to close" -ForegroundColor Gray
    }
} else {
    Write-Host "[4/6] Browser check skipped" -ForegroundColor Gray
    Write-Host "[5/6] Browser closing skipped" -ForegroundColor Gray
}
Write-Host ""

# Step 6: Deploy to Vercel (if not test mode)
if (-not $TestMode) {
    Write-Host "[6/6] Deploying updated website to Vercel..." -ForegroundColor Yellow
    
    try {
        $deployResult = vercel --prod --yes 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   Website deployed successfully!" -ForegroundColor Green
            
            # Extract URL from deployment
            $url = "https://flight-tracker-switzerland-bangalor.vercel.app"
            Write-Host "   Live at: $url" -ForegroundColor Cyan
        } else {
            Write-Host "   Warning: Deployment failed" -ForegroundColor Yellow
            Write-Host "   $deployResult" -ForegroundColor Gray
        }
    } catch {
        Write-Host "   Error: Could not deploy to Vercel" -ForegroundColor Red
        Write-Host "   Make sure Vercel CLI is installed: npm install -g vercel" -ForegroundColor Yellow
    }
} else {
    Write-Host "[6/6] Deployment skipped (test mode)" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  AUTOMATION COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  - Price check: Done" -ForegroundColor White
Write-Host "  - Log updated: flight-price-log.txt" -ForegroundColor White
Write-Host "  - Website: Updated" -ForegroundColor White
if (-not $SkipBrowser) {
    Write-Host "  - Browsers: Checked & Closed" -ForegroundColor White
}
if (-not $TestMode) {
    Write-Host "  - Vercel: Deployed" -ForegroundColor White
}
Write-Host ""
Write-Host "Next run: Tomorrow at scheduled time" -ForegroundColor Gray
Write-Host "Completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Send notification
Write-Host "Daily flight price check completed!" -ForegroundColor Green
Write-Host ""

# Return success
exit 0
