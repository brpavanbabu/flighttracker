##############################################################################
# UPDATE WEBSITE WITH MOLTBOT PRICES
# Takes moltbot-flight-prices.json and updates index.html
##############################################################################

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  UPDATING WEBSITE WITH REAL PRICES" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check if results file exists
if (-not (Test-Path "moltbot-flight-prices.json")) {
    Write-Host "✗ Error: moltbot-flight-prices.json not found" -ForegroundColor Red
    Write-Host "  Run moltbot-flight-checker.ps1 first!" -ForegroundColor Yellow
    exit 1
}

# Load results
Write-Host "Loading flight data..." -ForegroundColor Gray
$flights = Get-Content "moltbot-flight-prices.json" | ConvertFrom-Json

Write-Host "Found $($flights.Count) cities with prices" -ForegroundColor Green
Write-Host ""

# Generate flight cards HTML
$flightCardsHtml = ""
foreach ($flight in $flights) {
    $flightCardsHtml += @"

                <div class="flight-card" data-city="$($flight.city)">
                    <div class="airport-info">
                        <div class="city-name">$($flight.city)</div>
                        <div class="airport-code">$($flight.code)</div>
                        <div class="state-name">$($flight.state)</div>
                    </div>
                    <div class="price-info">
                        <div class="price">CHF $($flight.price)</div>
                        <div class="dates">$($flight.depDate) to $($flight.retDate)</div>
                        <div class="airline">$($flight.airline) • $($flight.stops) stop</div>
                        <div class="duration">$($flight.duration)</div>
                    </div>
                    <div class="actions">
                        <a href="https://www.google.com/travel/flights?q=Flights%20to%20$($flight.code)%20from%20ZRH%20on%20$($flight.depDate)%20through%20$($flight.retDate)" target="_blank" class="book-btn">Book Now ↗</a>
                    </div>
                </div>
"@
}

# Find cheapest
$cheapest = $flights | Sort-Object -Property price | Select-Object -First 1

# Read current index.html
$htmlContent = Get-Content "index.html" -Raw

# Update the flights container
$pattern = '(?s)(<div class="flights-container">).*?(</div>\s*<!-- End of flights -->)'
$replacement = "`$1$flightCardsHtml`n            `$2"
$htmlContent = $htmlContent -replace $pattern, $replacement

# Update last updated timestamp
$timestamp = Get-Date -Format "MMMM dd, yyyy HH:mm"
$htmlContent = $htmlContent -replace 'Last Updated:.*?<', "Last Updated: $timestamp <"

# Update best deal banner
$bestDealHtml = @"
<div class="best-deal-banner">
                    <div class="banner-icon">🏆</div>
                    <div class="banner-content">
                        <div class="banner-title">Best Deal Alert!</div>
                        <div class="banner-text">
                            <strong>$($cheapest.city)</strong> for just <strong>CHF $($cheapest.price)</strong>
                            via $($cheapest.airline) • Departure: $($cheapest.depDate)
                        </div>
                    </div>
                </div>
"@

$bannerPattern = '(?s)(<div class="best-deal-banner">).*?(</div>\s*</div>\s*<!-- End best deal -->)'
$htmlContent = $htmlContent -replace $bannerPattern, $bestDealHtml

# Save updated HTML
Set-Content -Path "index.html" -Value $htmlContent -Encoding UTF8

Write-Host "✓ Website updated successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Cheapest flight: $($cheapest.city) - CHF $($cheapest.price)" -ForegroundColor Cyan
Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  DEPLOYING TO VERCEL" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Deploy to Vercel
Write-Host "Pushing to GitHub..." -ForegroundColor Yellow
git add moltbot-flight-prices.json index.html
git commit -m "Update prices: Cheapest is $($cheapest.city) CHF $($cheapest.price) (Moltbot)"
git push

Write-Host ""
Write-Host "✓ Pushed to GitHub - Vercel will auto-deploy!" -ForegroundColor Green
Write-Host ""
Write-Host "Your website will update in ~30 seconds" -ForegroundColor Cyan
Write-Host ""
