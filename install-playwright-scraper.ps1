# Install Python Playwright Scraper for Accurate Flight Prices

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  INSTALLING ADVANCED PRICE SCRAPER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Check Python
Write-Host "Checking for Python..." -ForegroundColor Yellow
$python = Get-Command python -ErrorAction SilentlyContinue

if (-not $python) {
    Write-Host "Python not found!" -ForegroundColor Red
    Write-Host ""
    Write-Host "Installing Python..." -ForegroundColor Yellow
    Write-Host ""
    
    # Download and install Python
    Write-Host "Opening Python download page..." -ForegroundColor Cyan
    Start-Process "https://www.python.org/downloads/"
    
    Write-Host ""
    Write-Host "Please:" -ForegroundColor Yellow
    Write-Host "  1. Download and install Python" -ForegroundColor White
    Write-Host "  2. Check 'Add Python to PATH'" -ForegroundColor White
    Write-Host "  3. Run this script again after installation" -ForegroundColor White
    Write-Host ""
    
    exit 1
}

Write-Host "Python found: $($python.Version)" -ForegroundColor Green
Write-Host ""

# Install required packages
Write-Host "Installing required Python packages..." -ForegroundColor Yellow
Write-Host ""

python -m pip install --upgrade pip
python -m pip install playwright beautifulsoup4 requests

Write-Host ""
Write-Host "Installing Playwright browsers..." -ForegroundColor Yellow
python -m playwright install chromium

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  CREATING SCRAPER SCRIPT" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

# Create Python scraper script
$pythonScript = @'
"""
Real-Time Flight Price Scraper
Uses Playwright to get actual prices from Google Flights
"""

import asyncio
from playwright.async_api import async_playwright
import json
from datetime import datetime

async def scrape_flight_price(from_city, to_city, dep_date, ret_date):
    """Scrape price for a specific route"""
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        # Build Google Flights URL
        url = f"https://www.google.com/travel/flights?q=Flights%20to%20{to_city}%20from%20{from_city}%20on%20{dep_date}%20through%20{ret_date}"
        
        try:
            await page.goto(url, wait_until="networkidle", timeout=30000)
            await page.wait_for_timeout(5000)  # Wait for prices to load
            
            # Try to extract price
            price_elements = await page.query_selector_all('[role="text"]')
            
            for element in price_elements:
                text = await element.inner_text()
                if 'CHF' in text:
                    # Extract number from price
                    price_str = text.replace('CHF', '').replace(',', '').strip()
                    try:
                        price = int(''.join(filter(str.isdigit, price_str)))
                        await browser.close()
                        return price
                    except:
                        continue
            
            await browser.close()
            return None
            
        except Exception as e:
            print(f"Error scraping {from_city} to {to_city}: {e}")
            await browser.close()
            return None

async def main():
    """Main scraping function"""
    routes = [
        {"from": "ZRH", "to": "DEL", "city": "Delhi", "dep": "2026-07-14", "ret": "2026-08-14"},
        {"from": "ZRH", "to": "BOM", "city": "Mumbai", "dep": "2026-07-14", "ret": "2026-08-14"},
        {"from": "ZRH", "to": "BLR", "city": "Bangalore", "dep": "2026-07-21", "ret": "2026-08-21"},
        {"from": "ZRH", "to": "MAA", "city": "Chennai", "dep": "2026-07-14", "ret": "2026-08-14"},
        {"from": "ZRH", "to": "HYD", "city": "Hyderabad", "dep": "2026-07-21", "ret": "2026-08-21"},
        {"from": "ZRH", "to": "VGA", "city": "Vijayawada", "dep": "2026-07-14", "ret": "2026-08-14"},
        {"from": "ZRH", "to": "VTZ", "city": "Visakhapatnam", "dep": "2026-07-21", "ret": "2026-08-21"},
    ]
    
    results = []
    
    for route in routes:
        print(f"Checking {route['city']}...")
        price = await scrape_flight_price(
            route['from'], 
            route['to'], 
            route['dep'], 
            route['ret']
        )
        
        results.append({
            "city": route['city'],
            "code": route['to'],
            "price": price if price else "Not available",
            "depDate": route['dep'],
            "retDate": route['ret'],
            "timestamp": datetime.now().isoformat()
        })
        
        print(f"  {route['city']}: CHF {price if price else 'N/A'}")
    
    # Save results
    with open('live-flight-prices.json', 'w') as f:
        json.dump(results, f, indent=2)
    
    print("\nResults saved to: live-flight-prices.json")
    return results

if __name__ == "__main__":
    print("Real-Time Flight Price Scraper")
    print("=" * 40)
    print()
    asyncio.run(main())
'@

$pythonScript | Out-File -FilePath "scrape_prices.py" -Encoding UTF8

Write-Host "Python scraper created: scrape_prices.py" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Green
Write-Host "  INSTALLATION COMPLETE!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "To get real-time prices, run:" -ForegroundColor Cyan
Write-Host "  python scrape_prices.py" -ForegroundColor White
Write-Host ""
Write-Host "Or use PowerShell wrapper:" -ForegroundColor Cyan
Write-Host "  .\get-real-prices.ps1 -UpdateWebsite" -ForegroundColor White
Write-Host ""

Write-Host "Testing the scraper now..." -ForegroundColor Yellow
Write-Host ""

python scrape_prices.py

Write-Host ""
Write-Host "Done! Check live-flight-prices.json for results" -ForegroundColor Green
Write-Host ""
