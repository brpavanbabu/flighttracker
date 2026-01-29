"""
REAL Flight Price Scraper - NO ASSUMPTIONS
Gets actual live prices from Google Flights using Playwright
"""

import asyncio
from playwright.async_api import async_playwright
import json
from datetime import datetime
import re

async def get_real_price(from_code, to_code, dep_date, ret_date, city_name):
    """Get REAL price from Google Flights - NO assumptions"""
    
    async with async_playwright() as p:
        print(f"  Launching browser for {city_name}...")
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        try:
            # Build Google Flights URL
            url = f"https://www.google.com/travel/flights?q=Flights%20to%20{to_code}%20from%20{from_code}%20on%20{dep_date}%20through%20{ret_date}&curr=CHF"
            
            print(f"  Loading Google Flights...")
            await page.goto(url, wait_until="networkidle", timeout=60000)
            
            # Wait for prices to load
            print(f"  Waiting for prices to load...")
            await page.wait_for_timeout(8000)
            
            # Try multiple selectors to find prices
            price = None
            
            # Method 1: Look for CHF price elements
            price_elements = await page.query_selector_all('text=/CHF/')
            for element in price_elements:
                text = await element.inner_text()
                # Extract CHF price
                match = re.search(r'CHF\s*([0-9,]+)', text)
                if match:
                    price_str = match.group(1).replace(',', '')
                    try:
                        price = int(price_str)
                        if 200 < price < 5000:  # Reasonable range
                            print(f"  [OK] Found price: CHF {price}")
                            break
                    except:
                        continue
            
            # Method 2: Get page content and search
            if not price:
                content = await page.content()
                matches = re.findall(r'CHF\s*([0-9,]+)', content)
                for match in matches:
                    try:
                        price_val = int(match.replace(',', ''))
                        if 200 < price_val < 5000:
                            price = price_val
                            print(f"  [OK] Found price: CHF {price}")
                            break
                    except:
                        continue
            
            await browser.close()
            
            if price:
                return {
                    "city": city_name,
                    "code": to_code,
                    "price": price,
                    "depDate": dep_date,
                    "retDate": ret_date,
                    "method": "LIVE",
                    "source": "Google Flights",
                    "timestamp": datetime.now().isoformat()
                }
            else:
                print(f"  [WARN] Could not find price for {city_name}")
                return {
                    "city": city_name,
                    "code": to_code,
                    "price": None,
                    "depDate": dep_date,
                    "retDate": ret_date,
                    "method": "FAILED",
                    "source": "Google Flights",
                    "timestamp": datetime.now().isoformat()
                }
                
        except Exception as e:
            print(f"  [ERROR] Error for {city_name}: {str(e)}")
            await browser.close()
            return {
                "city": city_name,
                "code": to_code,
                "price": None,
                "depDate": dep_date,
                "retDate": ret_date,
                "method": "ERROR",
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }

async def main():
    """Main function - Get REAL prices for all cities"""
    
    print("=" * 60)
    print("REAL FLIGHT PRICE SCRAPER - NO ASSUMPTIONS")
    print("=" * 60)
    print()
    
    # Cities to check
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
        print(f"\n[{routes.index(route)+1}/{len(routes)}] Checking {route['city']}...")
        print("-" * 60)
        
        result = await get_real_price(
            route['from'],
            route['to'],
            route['dep'],
            route['ret'],
            route['city']
        )
        
        results.append(result)
    
    print("\n" + "=" * 60)
    print("RESULTS:")
    print("=" * 60)
    print()
    
    # Display results
    live_count = 0
    failed_count = 0
    
    for result in results:
        if result['method'] == 'LIVE' and result['price']:
            print(f"[OK] {result['city']:15} CHF {result['price']:4}  [LIVE PRICE]")
            live_count += 1
        else:
            print(f"[FAIL] {result['city']:15} ---         [NO PRICE FOUND]")
            failed_count += 1
    
    print()
    print(f"Live prices: {live_count}/{len(results)}")
    print(f"Failed: {failed_count}/{len(results)}")
    print()
    
    # Save results
    output_file = f'live-prices-{datetime.now().strftime("%Y-%m-%d-%H%M%S")}.json'
    with open(output_file, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"Results saved to: {output_file}")
    print()
    
    # Also save latest
    with open('live-prices-latest.json', 'w') as f:
        json.dump(results, f, indent=2)
    
    print("Latest results: live-prices-latest.json")
    print()
    
    return results

if __name__ == "__main__":
    print()
    asyncio.run(main())
