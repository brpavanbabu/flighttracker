# Setup Live Flight Price Tracking
# Configures Brave Search API for real-time prices

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SETUP LIVE PRICE TRACKING" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "To get ACTUAL live prices, you need a Brave Search API key" -ForegroundColor Yellow
Write-Host ""
Write-Host "Steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Get FREE API Key:" -ForegroundColor White
Write-Host "   Visit: https://brave.com/search/api/" -ForegroundColor Cyan
Write-Host "   - Sign up (it's FREE!)" -ForegroundColor Gray
Write-Host "   - Free tier: 2000 searches/month" -ForegroundColor Gray
Write-Host "   - Get your API key" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Configure Moltbot with API key:" -ForegroundColor White
Write-Host ""

$apiKey = Read-Host "Enter your Brave Search API key (or press Enter to skip)"

if ($apiKey) {
    Write-Host ""
    Write-Host "Configuring Moltbot..." -ForegroundColor Yellow
    
    try {
        # Configure Brave Search in Moltbot
        clawdbot config set integrations.braveSearch.apiKey "$apiKey"
        
        Write-Host "✅ API key configured!" -ForegroundColor Green
        Write-Host ""
        Write-Host "Testing web search..." -ForegroundColor Yellow
        
        # Test query
        $testQuery = "What is the weather today?"
        $testResult = clawdbot agent --to +1234567890 --message $testQuery --local 2>&1
        
        if ($testResult -match "error") {
            Write-Host "⚠️ Warning: Web search may not be working" -ForegroundColor Yellow
            Write-Host "But we'll try with flight prices..." -ForegroundColor Gray
        } else {
            Write-Host "✅ Web search working!" -ForegroundColor Green
        }
        
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Green
        Write-Host "  READY FOR LIVE PRICES!" -ForegroundColor Green
        Write-Host "========================================" -ForegroundColor Green
        Write-Host ""
        Write-Host "Now when you run the checker, it will:" -ForegroundColor Cyan
        Write-Host "  - Search Google Flights for real prices" -ForegroundColor White
        Write-Host "  - Get current availability" -ForegroundColor White
        Write-Host "  - Show actual booking prices" -ForegroundColor White
        Write-Host ""
        
    } catch {
        Write-Host "❌ Error configuring API key" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
    }
} else {
    Write-Host ""
    Write-Host "Skipped API key setup" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To add later, run:" -ForegroundColor Cyan
    Write-Host '  clawdbot config set integrations.braveSearch.apiKey "YOUR_KEY"' -ForegroundColor Gray
    Write-Host ""
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "ALTERNATIVE: Use Flight Search APIs" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "For even more accurate prices, consider:" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Skyscanner API" -ForegroundColor White
Write-Host "   https://partners.skyscanner.net/" -ForegroundColor Cyan
Write-Host "   - Official flight price API" -ForegroundColor Gray
Write-Host "   - Requires partnership" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Google Flights API (unofficial)" -ForegroundColor White
Write-Host "   - Use SerpAPI: https://serpapi.com/" -ForegroundColor Cyan
Write-Host "   - \$50/month for 5000 searches" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Amadeus API" -ForegroundColor White
Write-Host "   https://developers.amadeus.com/" -ForegroundColor Cyan
Write-Host "   - Free tier available" -ForegroundColor Gray
Write-Host "   - Real airline data" -ForegroundColor Gray
Write-Host ""

Write-Host "For now, Brave Search API is best for free solution!" -ForegroundColor Green
Write-Host ""
