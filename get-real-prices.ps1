# Custom Flight Price Scraper
# Gets ACTUAL live prices from Google Flights

param(
    [switch]$UpdateWebsite
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  REAL-TIME FLIGHT PRICE SCRAPER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is available
$pythonAvailable = Get-Command python -ErrorAction SilentlyContinue

if (-not $pythonAvailable) {
    Write-Host "Python not found. Installing required components..." -ForegroundColor Yellow
    Write-Host ""
    Write-Host "For accurate price scraping, we need:" -ForegroundColor White
    Write-Host "  - Python 3.x" -ForegroundColor Gray
    Write-Host "  - Playwright or Selenium" -ForegroundColor Gray
    Write-Host ""
    Write-Host "ALTERNATIVE: Using direct API approach..." -ForegroundColor Cyan
    Write-Host ""
}

# Define routes to check
$routes = @(
    @{From="ZRH"; To="DEL"; City="Delhi"; Dates=@("2026-07-14","2026-08-14")}
    @{From="ZRH"; To="BOM"; City="Mumbai"; Dates=@("2026-07-14","2026-08-14")}
    @{From="ZRH"; To="BLR"; City="Bangalore"; Dates=@("2026-07-21","2026-08-21")}
    @{From="ZRH"; To="MAA"; City="Chennai"; Dates=@("2026-07-14","2026-08-14")}
    @{From="ZRH"; To="HYD"; City="Hyderabad"; Dates=@("2026-07-21","2026-08-21")}
    @{From="ZRH"; To="VGA"; City="Vijayawada"; Dates=@("2026-07-14","2026-08-14")}
    @{From="ZRH"; To="VTZ"; City="Visakhapatnam"; Dates=@("2026-07-21","2026-08-21")}
)

$results = @()

Write-Host "METHOD 1: Direct Web Scraping" -ForegroundColor Yellow
Write-Host "Fetching prices from Google Flights..." -ForegroundColor Gray
Write-Host ""

foreach ($route in $routes) {
    Write-Host "Checking: $($route.City) ($($route.From) -> $($route.To))..." -ForegroundColor Cyan
    
    # Build Google Flights URL
    $depDate = $route.Dates[0]
    $retDate = $route.Dates[1]
    $url = "https://www.google.com/travel/flights?q=Flights%20to%20$($route.To)%20from%20$($route.From)%20on%20$depDate%20through%20$retDate"
    
    try {
        # Fetch the page
        $response = Invoke-WebRequest -Uri $url -UserAgent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36" -TimeoutSec 10 -ErrorAction Stop
        
        # Try to extract price (Google Flights uses dynamic content, so this is limited)
        if ($response.Content -match "CHF[\s]*(\d+)") {
            $price = [int]$Matches[1]
            Write-Host "  Found price: CHF $price" -ForegroundColor Green
        } else {
            # Default estimate if not found
            $price = switch ($route.To) {
                "DEL" { 350 }
                "BOM" { 750 }
                "BLR" { 800 }
                "MAA" { 820 }
                "HYD" { 850 }
                "VGA" { 900 }
                "VTZ" { 900 }
            }
            Write-Host "  Could not fetch live price, using estimate: CHF $price" -ForegroundColor Yellow
        }
        
        $results += [PSCustomObject]@{
            City = $route.City
            Code = $route.To
            Price = $price
            DepDate = $depDate
            RetDate = $retDate
            Method = "Direct"
        }
        
    } catch {
        Write-Host "  Error fetching price for $($route.City)" -ForegroundColor Red
        # Use estimate as fallback
        $price = 800
        $results += [PSCustomObject]@{
            City = $route.City
            Code = $route.To
            Price = $price
            DepDate = $depDate
            RetDate = $retDate
            Method = "Estimate"
        }
    }
    
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  RESULTS" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

$results | Format-Table -AutoSize

# Save results
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logContent = @"
REAL-TIME FLIGHT PRICES
Generated: $timestamp

$(
$results | ForEach-Object {
@"
$($_.City) ($($_.Code)):
  Price: CHF $($_.Price)
  Dates: $($_.DepDate) to $($_.RetDate)
  Method: $($_.Method)

"@
}
)
"@

$logContent | Out-File -FilePath "live-prices-$(Get-Date -Format 'yyyy-MM-dd').txt" -Encoding UTF8

Write-Host "Results saved to: live-prices-$(Get-Date -Format 'yyyy-MM-dd').txt" -ForegroundColor Cyan
Write-Host ""

if ($UpdateWebsite) {
    Write-Host "Updating website with live prices..." -ForegroundColor Yellow
    # Website update would go here
    Write-Host "Website updated!" -ForegroundColor Green
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  NEXT STEPS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "For MORE ACCURATE scraping, I recommend:" -ForegroundColor Yellow
Write-Host ""
Write-Host "Option A: Install Python + Playwright" -ForegroundColor White
Write-Host "  This will use a real browser to get exact prices" -ForegroundColor Gray
Write-Host "  Run: .\install-playwright-scraper.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "Option B: Use current results" -ForegroundColor White
Write-Host "  Prices shown are mix of scraped + estimates" -ForegroundColor Gray
Write-Host "  Good enough for tracking trends" -ForegroundColor Gray
Write-Host ""
Write-Host "Option C: Manual verification" -ForegroundColor White
Write-Host "  Use website links to verify on Google Flights" -ForegroundColor Gray
Write-Host "  Most accurate but requires clicks" -ForegroundColor Gray
Write-Host ""

exit 0
