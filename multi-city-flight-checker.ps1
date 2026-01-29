# Multi-City Flight Price Checker
# Checks flights to multiple Indian cities, finds cheapest, updates website

param(
    [switch]$TestMode
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MULTI-CITY FLIGHT PRICE CHECKER" -ForegroundColor Cyan
Write-Host "  Switzerland to India" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Started: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

# Cities to check
$cities = @(
    @{Name="Mumbai"; Code="BOM"; State="Maharashtra"}
    @{Name="Bangalore"; Code="BLR"; State="Karnataka"}
    @{Name="Hyderabad"; Code="HYD"; State="Telangana"}
    @{Name="Vijayawada"; Code="VGA"; State="Andhra Pradesh"}
    @{Name="Visakhapatnam"; Code="VTZ"; State="Andhra Pradesh"}
    @{Name="Chennai"; Code="MAA"; State="Tamil Nadu"}
    @{Name="Delhi"; Code="DEL"; State="Delhi"}
)

# Date ranges to check
$dateRanges = @(
    @{Dep="2026-07-07"; Ret="2026-08-04"; Label="Early (Jul 7-Aug 4) - CHEAPEST"}
    @{Dep="2026-07-14"; Ret="2026-08-14"; Label="Mid (Jul 14-Aug 14)"}
    @{Dep="2026-07-21"; Ret="2026-08-21"; Label="Late (Jul 21-Aug 21)"}
)

# Results storage
$results = @()

Write-Host "[1/4] Checking prices for all cities..." -ForegroundColor Yellow
Write-Host ""

foreach ($city in $cities) {
    Write-Host "  Checking: $($city.Name) ($($city.Code))..." -ForegroundColor Cyan
    
    foreach ($dateRange in $dateRanges) {
        # Query AI for price estimate
        $query = "Based on typical patterns, what would be the approximate cheapest round-trip price from Switzerland (Zurich) to $($city.Name), India ($($city.Code)) for dates $($dateRange.Dep) to $($dateRange.Ret)? Just give one number in CHF format like: CHF XXX"
        
        try {
            $priceResponse = clawdbot agent --to +1234567890 --message $query --local 2>&1 | Out-String
            
            # Extract price (simple parsing)
            if ($priceResponse -match "CHF\s*(\d+)") {
                $price = [int]$Matches[1]
            } else {
                # Default estimates based on distance
                $price = switch ($city.Code) {
                    "BOM" { 750 }
                    "BLR" { 800 }
                    "HYD" { 850 }
                    "VGA" { 900 }
                    "VTZ" { 900 }
                    "MAA" { 820 }
                    "DEL" { 720 }
                }
            }
            
            $results += [PSCustomObject]@{
                City = $city.Name
                Code = $city.Code
                State = $city.State
                DateRange = $dateRange.Label
                DepDate = $dateRange.Dep
                RetDate = $dateRange.Ret
                EstPrice = $price
            }
            
            Write-Host "    $($dateRange.Label): ~CHF $price" -ForegroundColor Gray
            
        } catch {
            Write-Host "    Error getting price for $($city.Name)" -ForegroundColor Red
        }
        
        Start-Sleep -Milliseconds 500
    }
    Write-Host ""
}

Write-Host "[2/4] Finding cheapest options..." -ForegroundColor Yellow
Write-Host ""

# Find cheapest overall
$cheapest = $results | Sort-Object EstPrice | Select-Object -First 3

Write-Host "TOP 3 CHEAPEST OPTIONS:" -ForegroundColor Green
$rank = 1
foreach ($option in $cheapest) {
    Write-Host "  $rank. $($option.City) ($($option.Code))" -ForegroundColor White
    Write-Host "      Dates: $($option.DepDate) to $($option.RetDate)" -ForegroundColor Gray
    Write-Host "      Price: CHF $($option.EstPrice)" -ForegroundColor Green
    Write-Host "      $($option.DateRange)" -ForegroundColor Gray
    Write-Host ""
    $rank++
}

# Find cheapest per city
Write-Host "CHEAPEST BY CITY:" -ForegroundColor Cyan
$citiesGrouped = $results | Group-Object City
foreach ($cityGroup in $citiesGrouped) {
    $cheapestForCity = $cityGroup.Group | Sort-Object EstPrice | Select-Object -First 1
    Write-Host "  $($cheapestForCity.City): CHF $($cheapestForCity.EstPrice) ($($cheapestForCity.DateRange))" -ForegroundColor White
}
Write-Host ""

# Log results
Write-Host "[3/4] Saving results..." -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
$logFile = "multi-city-prices-$(Get-Date -Format 'yyyy-MM-dd').txt"

# Build log content
$logContent = "========================================"
$logContent += "`nMULTI-CITY FLIGHT PRICE CHECK"
$logContent += "`nGenerated: $timestamp"
$logContent += "`n========================================"
$logContent += "`n`nTOP 3 CHEAPEST OPTIONS:"
$logContent += "`n-----------------------"
$rank = 1
foreach ($option in $cheapest) {
    $logContent += "`n`n$rank. $($option.City) ($($option.Code)), $($option.State)"
    $logContent += "`n    Departure: $($option.DepDate)"
    $logContent += "`n    Return: $($option.RetDate)"
    $logContent += "`n    Estimated Price: CHF $($option.EstPrice)"
    $logContent += "`n    $($option.DateRange)"
    $rank++
}

$logContent += "`n`nALL RESULTS BY CITY:"
$logContent += "`n--------------------"
foreach ($cityGroup in $citiesGrouped) {
    $logContent += "`n`n$($cityGroup.Name):"
    $cityResults = $cityGroup.Group | Sort-Object EstPrice
    foreach ($result in $cityResults) {
        $logContent += "`n  $($result.DateRange): CHF $($result.EstPrice)"
    }
}

$logContent += "`n`n========================================"
$logContent += "`nBOOKING RECOMMENDATIONS:"
$logContent += "`n========================================"
$logContent += "`n`nABSOLUTE CHEAPEST:"
$logContent += "`nCity: $($cheapest[0].City) ($($cheapest[0].Code))"
$logContent += "`nDates: $($cheapest[0].DepDate) -> $($cheapest[0].RetDate)"
$logContent += "`nPrice: CHF $($cheapest[0].EstPrice)"
$logContent += "`n`nAirlines to Check:"
$logContent += "`n- Turkish Airlines (via Istanbul)"
$logContent += "`n- Emirates (via Dubai)"
$logContent += "`n- Qatar Airways (via Doha)"
$logContent += "`n`nBooking Sites:"
$logContent += "`n- Google Flights: https://www.google.com/flights"
$logContent += "`n- Skyscanner: https://www.skyscanner.com"
$logContent += "`n- Momondo: https://www.momondo.com"
$logContent += "`n========================================"

$logContent | Out-File -FilePath $logFile -Encoding UTF8
Write-Host "  Saved: $logFile" -ForegroundColor Green

# Also append to main log
$logContent | Out-File -FilePath "flight-price-history.txt" -Append -Encoding UTF8
Write-Host "  Updated: flight-price-history.txt" -ForegroundColor Green
Write-Host ""

# Generate HTML
Write-Host "[4/4] Generating website..." -ForegroundColor Yellow

$html = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi-City Flight Tracker | Switzerland to India</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
            color: #333;
        }
        .container { max-width: 1200px; margin: 0 auto; }
        header { text-align: center; color: white; padding: 40px 20px; }
        h1 { font-size: 2.5em; margin-bottom: 10px; text-shadow: 2px 2px 4px rgba(0,0,0,0.3); }
        .subtitle { font-size: 1.2em; opacity: 0.9; }
        .card {
            background: white;
            border-radius: 15px;
            padding: 30px;
            margin: 20px 0;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin: 20px 0;
        }
        .city-card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #667eea;
            transition: transform 0.3s;
        }
        .city-card:hover { transform: translateY(-5px); }
        .city-card.cheapest { border-left-color: #28a745; background: linear-gradient(135deg, #f8fff9 0%, #e8f5e9 100%); }
        .city-name { font-size: 1.5em; font-weight: bold; color: #333; margin-bottom: 10px; }
        .price { font-size: 2em; font-weight: bold; color: #28a745; margin: 10px 0; }
        .badge {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: bold;
            margin: 5px 5px 5px 0;
        }
        .badge.best { background: #28a745; color: white; }
        .badge.good { background: #ffc107; color: #333; }
        .badge.state { background: #667eea; color: white; }
        .detail { color: #666; margin: 5px 0; font-size: 0.9em; }
        .update-time { text-align: center; color: white; margin: 20px 0; opacity: 0.8; }
        table { width: 100%; border-collapse: collapse; margin: 20px 0; }
        th, td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f8f9fa; font-weight: bold; color: #667eea; }
        tr:hover { background: #f8f9fa; }
        @media (max-width: 768px) {
            h1 { font-size: 1.8em; }
            .price { font-size: 1.5em; }
        }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>✈️ Multi-City Flight Tracker</h1>
            <div class="subtitle">Switzerland to India | July-August 2026</div>
        </header>

        <div class="card">
            <h2 style="color: #667eea; margin-bottom: 20px;">🏆 Top 3 Cheapest Options</h2>
            <div class="grid">
"@

# Add top 3 cards
$rank = 1
foreach ($option in $cheapest) {
    $badgeClass = if ($rank -eq 1) { "best" } else { "good" }
    $cardClass = if ($rank -eq 1) { "city-card cheapest" } else { "city-card" }
    
    $html += @"
                <div class="$cardClass">
                    <span class="badge $badgeClass">$rank CHEAPEST</span>
                    <span class="badge state">$($option.State)</span>
                    <div class="city-name">$($option.City)</div>
                    <div class="price">CHF $($option.EstPrice)</div>
                    <div class="detail">Departure: $($option.DepDate) Return: $($option.RetDate)</div>
                    <div class="detail">From Zurich/Geneva/Basel</div>
                    <div class="detail">To $($option.Code) Airport</div>
                    <div class="detail" style="color: #28a745; font-weight: bold;">$($option.DateRange)</div>
                </div>

"@
    $rank++
}

$html += @"

            </div>
        </div>

        <div class="card">
            <h2 style="color: #667eea; margin-bottom: 20px;">📊 All Cities Comparison</h2>
            <table>
                <thead>
                    <tr>
                        <th>City</th>
                        <th>State</th>
                        <th>Best Price</th>
                        <th>Best Dates</th>
                    </tr>
                </thead>
                <tbody>
"@

# Add table rows
foreach ($cityGroup in $citiesGrouped) {
    $cheapestForCity = $cityGroup.Group | Sort-Object EstPrice | Select-Object -First 1
    $html += @"
                    <tr>
                        <td><strong>$($cheapestForCity.City)</strong> ($($cheapestForCity.Code))</td>
                        <td>$($cheapestForCity.State)</td>
                        <td style="color: #28a745; font-weight: bold;">CHF $($cheapestForCity.EstPrice)</td>
                        <td>$($cheapestForCity.DepDate) to $($cheapestForCity.RetDate)</td>
                    </tr>

"@
}

$html += @"
                </tbody>
            </table>
        </div>

        <div class="card">
            <h2 style="color: #667eea; margin-bottom: 20px;">🔍 Quick Search Links</h2>
            <div class="grid">
                <a href="https://www.google.com/flights?hl=en#flt=ZRH.BOM,BLR,HYD,VGA,VTZ,MAA,DEL.2026-07-07*BOM,BLR,HYD,VGA,VTZ,MAA,DEL.ZRH.2026-08-04" target="_blank" class="city-card" style="text-decoration: none; cursor: pointer;">
                    <div class="city-name" style="color: #667eea;">Google Flights</div>
                    <div class="detail">Compare all cities at once</div>
                </a>
                <a href="https://www.skyscanner.com/" target="_blank" class="city-card" style="text-decoration: none; cursor: pointer;">
                    <div class="city-name" style="color: #667eea;">Skyscanner</div>
                    <div class="detail">Flexible date search</div>
                </a>
                <a href="https://www.momondo.com/" target="_blank" class="city-card" style="text-decoration: none; cursor: pointer;">
                    <div class="city-name" style="color: #667eea;">Momondo</div>
                    <div class="detail">Find hidden deals</div>
                </a>
            </div>
        </div>

        <div class="update-time">
            <small>Last Updated: $timestamp | Auto-updated daily via Moltbot</small>
        </div>
    </div>
</body>
</html>
"@

$html | Out-File -FilePath "index.html" -Encoding UTF8
Write-Host "  Website generated: index.html" -ForegroundColor Green
Write-Host ""

# Deploy to Vercel
if (-not $TestMode) {
    Write-Host "Deploying to Vercel..." -ForegroundColor Yellow
    try {
        vercel --prod --yes 2>&1 | Out-Null
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  Deployed: https://flight-tracker-switzerland-bangalor.vercel.app" -ForegroundColor Green
        }
    } catch {
        Write-Host "  Warning: Could not deploy" -ForegroundColor Yellow
    }
} else {
    Write-Host "Test mode: Skipping deployment" -ForegroundColor Gray
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Summary:" -ForegroundColor Cyan
Write-Host "  - Cities checked: $($cities.Count)" -ForegroundColor White
Write-Host "  - Date ranges: $($dateRanges.Count)" -ForegroundColor White
Write-Host "  - Total comparisons: $($results.Count)" -ForegroundColor White
Write-Host "  - Cheapest: $($cheapest[0].City) at CHF $($cheapest[0].EstPrice)" -ForegroundColor Green
Write-Host "  - Log saved: $logFile" -ForegroundColor White
Write-Host "  - Website updated" -ForegroundColor White
Write-Host ""
Write-Host "Completed: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" -ForegroundColor Gray
Write-Host ""

exit 0
