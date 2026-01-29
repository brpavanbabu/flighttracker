# MOLTBOT - Get Real Google Flights Prices for ALL Cities
# Uses browser automation to extract actual July-August prices

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MOLTBOT FLIGHT PRICE CHECKER" -ForegroundColor Cyan
Write-Host "  July 15 - August 15, 2026" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$cities = @(
    @{Name="Bangalore"; Code="BLR"; State="Karnataka"},
    @{Name="Mumbai"; Code="BOM"; State="Maharashtra"},
    @{Name="Delhi"; Code="DEL"; State="Delhi"},
    @{Name="Chennai"; Code="MAA"; State="Tamil Nadu"},
    @{Name="Hyderabad"; Code="HYD"; State="Telangana"},
    @{Name="Vijayawada"; Code="VGA"; State="Andhra Pradesh"},
    @{Name="Visakhapatnam"; Code="VTZ"; State="Andhra Pradesh"}
)

$results = @()
$cityNum = 1

foreach ($city in $cities) {
    Write-Host ""
    Write-Host "[$cityNum/7] Checking $($city.Name)..." -ForegroundColor Yellow
    
    try {
        # Navigate to Google Flights for this city
        $url = "https://www.google.com/travel/flights?q=Flights%20to%20$($city.Code)%20from%20ZRH%20on%202026-07-15%20through%202026-08-15&curr=CHF"
        
        Write-Host "  Opening Google Flights..." -ForegroundColor Gray
        clawdbot browser navigate $url | Out-Null
        
        # Wait for page to load
        Write-Host "  Waiting for results..." -ForegroundColor Gray
        Start-Sleep -Seconds 12
        
        # Get snapshot
        Write-Host "  Extracting prices..." -ForegroundColor Gray
        $snapshot = clawdbot browser snapshot
        
        # Find prices
        $prices = $snapshot | Select-String "CHF\s*(\d{1,3}),?(\d{3})" -AllMatches | ForEach-Object {
            $_.Matches | ForEach-Object {
                $priceStr = $_.Value -replace "CHF\s*", "" -replace ",", ""
                [int]$priceStr
            }
        } | Where-Object { $_ -gt 400 -and $_ -lt 3000 } | Sort-Object | Select-Object -Unique
        
        if ($prices -and $prices.Count -gt 0) {
            $cheapestPrice = $prices[0]
            Write-Host "  Found: CHF $cheapestPrice" -ForegroundColor Green
            
            $results += @{
                city = $city.Name
                code = $city.Code
                state = $city.State
                price = $cheapestPrice
                depDate = "2026-07-15"
                retDate = "2026-08-15"
                timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
            }
        } else {
            Write-Host "  No prices found" -ForegroundColor Red
        }
        
    } catch {
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    $cityNum++
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  RESULTS SUMMARY" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

if ($results.Count -gt 0) {
    # Sort by price
    $results = $results | Sort-Object -Property price
    
    foreach ($result in $results) {
        Write-Host "$($result.city) ($($result.code)): CHF $($result.price)" -ForegroundColor White
    }
    
    # Save to JSON
    $jsonPath = "moltbot-flight-prices.json"
    $results | ConvertTo-Json -Depth 10 | Set-Content -Path $jsonPath -Encoding UTF8
    
    Write-Host ""
    Write-Host "Saved to: $jsonPath" -ForegroundColor Green
    Write-Host ""
    
    # Find cheapest
    $cheapest = $results[0]
    Write-Host "CHEAPEST: $($cheapest.city) - CHF $($cheapest.price)" -ForegroundColor Cyan
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "  NEXT: UPDATE WEBSITE" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Run: .\update-website-from-moltbot.ps1" -ForegroundColor White
    Write-Host ""
    
} else {
    Write-Host "No results found" -ForegroundColor Red
}
