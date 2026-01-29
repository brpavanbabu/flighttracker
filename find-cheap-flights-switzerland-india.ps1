# Find Cheapest Flights: Switzerland to India
# This script provides resources and strategies for finding cheap flights

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CHEAPEST FLIGHTS FINDER" -ForegroundColor Cyan
Write-Host "  Switzerland to India" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 1: Best Flight Search Websites" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "1. Google Flights" -ForegroundColor White
Write-Host "   https://www.google.com/flights" -ForegroundColor Cyan
Write-Host "   - Best for: Price tracking, flexible dates" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Skyscanner" -ForegroundColor White
Write-Host "   https://www.skyscanner.com" -ForegroundColor Cyan
Write-Host "   - Best for: Comparing multiple airlines" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Momondo" -ForegroundColor White
Write-Host "   https://www.momondo.com" -ForegroundColor Cyan
Write-Host "   - Best for: Finding hidden deals" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Kayak" -ForegroundColor White
Write-Host "   https://www.kayak.com" -ForegroundColor Cyan
Write-Host "   - Best for: Price alerts" -ForegroundColor Gray
Write-Host ""

Write-Host "Step 2: Swiss Airports to Check" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "- Zurich (ZRH) - Most international flights" -ForegroundColor White
Write-Host "- Geneva (GVA) - Good European connections" -ForegroundColor White
Write-Host "- Basel (BSL) - Sometimes cheaper" -ForegroundColor White
Write-Host ""

Write-Host "Step 3: Indian Destinations" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "Major cities (usually cheaper):" -ForegroundColor White
Write-Host "- Delhi (DEL)" -ForegroundColor Cyan
Write-Host "- Mumbai (BOM)" -ForegroundColor Cyan
Write-Host "- Bangalore (BLR)" -ForegroundColor Cyan
Write-Host "- Chennai (MAA)" -ForegroundColor Cyan
Write-Host ""

Write-Host "Step 4: Airlines to Consider" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "Budget-Friendly:" -ForegroundColor Yellow
Write-Host "- Air India (direct flights available)" -ForegroundColor White
Write-Host "- Emirates (via Dubai)" -ForegroundColor White
Write-Host "- Qatar Airways (via Doha)" -ForegroundColor White
Write-Host "- Turkish Airlines (via Istanbul)" -ForegroundColor White
Write-Host "- Etihad (via Abu Dhabi)" -ForegroundColor White
Write-Host ""

Write-Host "Step 5: Money-Saving Tips" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "1. Book 2-3 months in advance" -ForegroundColor White
Write-Host "2. Fly Tuesday/Wednesday (cheapest days)" -ForegroundColor White
Write-Host "3. Avoid peak seasons:" -ForegroundColor White
Write-Host "   - December-January (Christmas/New Year)" -ForegroundColor Gray
Write-Host "   - March-April (Spring break)" -ForegroundColor Gray
Write-Host "   - July-August (Summer holidays)" -ForegroundColor Gray
Write-Host "4. Consider one-stop flights (often 30-40% cheaper)" -ForegroundColor White
Write-Host "5. Use incognito mode when searching" -ForegroundColor White
Write-Host ""

Write-Host "Step 6: Cheapest Months" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "CHEAPEST: May, June, September, October" -ForegroundColor Green
Write-Host "MODERATE: February, November" -ForegroundColor Yellow
Write-Host "EXPENSIVE: December, January, March, July, August" -ForegroundColor Red
Write-Host ""

Write-Host "Step 7: Price Range Guide" -ForegroundColor Green
Write-Host "------------------------------------" -ForegroundColor Gray
Write-Host ""
Write-Host "Economy Class (Round Trip):" -ForegroundColor White
Write-Host "- Budget: CHF 400-600 (with connections)" -ForegroundColor Green
Write-Host "- Average: CHF 600-900 (direct or one-stop)" -ForegroundColor Yellow
Write-Host "- Peak: CHF 1000-1500+" -ForegroundColor Red
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Opening search websites for you..." -ForegroundColor Yellow
Write-Host ""

# Open flight search websites
Start-Process "https://www.google.com/flights?hl=en#flt=ZRH.DEL.2026-03-01*DEL.ZRH.2026-03-15;c:CHF;e:1;sd:1;t:f"
Start-Sleep -Milliseconds 500
Start-Process "https://www.skyscanner.com/transport/flights/zrh/in/"
Start-Sleep -Milliseconds 500
Start-Process "https://www.momondo.com/flight-search/ZRH-DEL"

Write-Host "Opened 3 flight search sites!" -ForegroundColor Green
Write-Host ""
Write-Host "QUICK ACTION ITEMS:" -ForegroundColor Yellow
Write-Host "1. Check prices on all 3 sites" -ForegroundColor White
Write-Host "2. Set up price alerts" -ForegroundColor White
Write-Host "3. Be flexible with dates (+/- 3 days)" -ForegroundColor White
Write-Host "4. Consider nearby airports" -ForegroundColor White
Write-Host ""

# Ask AI for personalized advice
Write-Host "Getting AI recommendations..." -ForegroundColor Cyan
Write-Host ""

$query = "Without using web search, based on typical patterns: What are the top 3 specific strategies for finding the absolute cheapest flights from Switzerland to India? Be very specific and actionable."

$advice = clawdbot agent --to +1234567890 --message $query --local 2>&1 | Out-String

Write-Host "AI ADVICE:" -ForegroundColor Green
Write-Host "----------" -ForegroundColor Gray
Write-Host $advice
Write-Host ""

# Save report
$report = @"
CHEAPEST FLIGHTS: SWITZERLAND TO INDIA
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm")

BEST BOOKING SITES:
1. Google Flights - https://www.google.com/flights
2. Skyscanner - https://www.skyscanner.com
3. Momondo - https://www.momondo.com
4. Kayak - https://www.kayak.com

SWISS AIRPORTS: Zurich (ZRH), Geneva (GVA), Basel (BSL)
INDIAN CITIES: Delhi, Mumbai, Bangalore, Chennai

BUDGET AIRLINES:
- Air India (direct)
- Emirates (via Dubai)
- Qatar Airways (via Doha)
- Turkish Airlines (via Istanbul)

CHEAPEST MONTHS: May, June, September, October
BEST DAYS: Tuesday, Wednesday

TYPICAL PRICES (Round Trip):
- Budget: CHF 400-600
- Average: CHF 600-900
- Peak: CHF 1000-1500+

TIPS:
1. Book 2-3 months in advance
2. Fly midweek
3. Avoid peak seasons
4. Consider one-stop flights
5. Use incognito mode
6. Set price alerts

AI RECOMMENDATIONS:
$advice
"@

$report | Out-File -FilePath "switzerland-india-flights.txt" -Encoding UTF8

Write-Host "Report saved: switzerland-india-flights.txt" -ForegroundColor Green
Write-Host ""
Write-Host "Happy flight hunting!" -ForegroundColor Cyan
Write-Host ""
