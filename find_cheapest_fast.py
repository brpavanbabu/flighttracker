"""
FAST FLIGHT SEARCH - Smart Route Selection
Only checks the most likely cheapest routes
~2-3 minutes instead of 11 minutes
"""

import asyncio
from playwright.async_api import async_playwright
import json
from datetime import datetime
import re

async def get_real_price(from_code, from_city, to_code, to_city, dep_date, ret_date):
    """Get REAL price from Google Flights"""
    
    async with async_playwright() as p:
        print(f"  Checking {from_city} -> {to_city}...")
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        try:
            url = f"https://www.google.com/travel/flights?q=Flights%20to%20{to_code}%20from%20{from_code}%20on%20{dep_date}%20through%20{ret_date}&curr=CHF"
            
            await page.goto(url, wait_until="networkidle", timeout=60000)
            await page.wait_for_timeout(8000)
            
            price = None
            
            # Find price
            price_elements = await page.query_selector_all('text=/CHF/')
            for element in price_elements:
                text = await element.inner_text()
                match = re.search(r'CHF\s*([0-9,]+)', text)
                if match:
                    price_str = match.group(1).replace(',', '')
                    try:
                        price = int(price_str)
                        if 200 < price < 5000:
                            print(f"    [OK] CHF {price}")
                            break
                    except:
                        continue
            
            if not price:
                content = await page.content()
                matches = re.findall(r'CHF\s*([0-9,]+)', content)
                for match in matches:
                    try:
                        price_val = int(match.replace(',', ''))
                        if 200 < price_val < 5000:
                            price = price_val
                            print(f"    [OK] CHF {price}")
                            break
                    except:
                        continue
            
            await browser.close()
            
            if not price:
                print(f"    [WARN] No price found")
            
            return {
                "fromCity": from_city,
                "fromCode": from_code,
                "toCity": to_city,
                "toCode": to_code,
                "price": price,
                "depDate": dep_date,
                "retDate": ret_date,
                "method": "LIVE" if price else "FAILED",
            }
                
        except Exception as e:
            print(f"    [ERROR] {str(e)[:50]}")
            await browser.close()
            return {
                "fromCity": from_city,
                "fromCode": from_code,
                "toCity": to_city,
                "toCode": to_code,
                "price": None,
                "depDate": dep_date,
                "retDate": ret_date,
                "method": "ERROR",
            }

async def main():
    """Smart search with flexible duration"""
    
    print()
    print("=" * 70)
    print("FLEXIBLE DATE SEARCH - July to August 2026")
    print("Finding the CHEAPEST flights for your trip duration")
    print("=" * 70)
    print()
    
    # Ask user for trip duration
    print("Select trip duration:")
    print("  1) 2 weeks (~14 days)")
    print("  2) 4 weeks (~28 days)")
    print()
    
    # For automation, default to 4 weeks (can be changed)
    import sys
    if len(sys.argv) > 1:
        duration_choice = sys.argv[1]
    else:
        duration_choice = "2"  # Default to 4 weeks
    
    if duration_choice == "1":
        trip_days = 14
        trip_label = "2 weeks"
    else:
        trip_days = 28
        trip_label = "4 weeks"
    
    print(f"Selected: {trip_label} trip")
    print()
    
    # Cities to check
    cities = [
        {"code": "DEL", "name": "Delhi"},
        {"code": "BOM", "name": "Mumbai"},
        {"code": "BLR", "name": "Bangalore"},
        {"code": "MAA", "name": "Chennai"},
        {"code": "HYD", "name": "Hyderabad"},
    ]
    
    # Date combinations to check (anytime in July → anytime in August)
    date_combos = [
        {"dep": "2026-07-01", "ret": "2026-08-01", "label": "Early Jul - Early Aug"},
        {"dep": "2026-07-07", "ret": "2026-08-04", "label": "Jul 7 - Aug 4 (Tue-Tue)"},
        {"dep": "2026-07-14", "ret": "2026-08-14", "label": "Mid Jul - Mid Aug"},
        {"dep": "2026-07-21", "ret": "2026-08-21", "label": "Late Jul - Late Aug"},
        {"dep": "2026-07-28", "ret": "2026-08-28", "label": "End Jul - End Aug"},
    ]
    
    # Build all combinations
    routes = []
    for city in cities:
        for dates in date_combos:
            routes.append({
                "from": "ZRH",
                "fromCity": "Zurich",
                "to": city["code"],
                "toCity": city["name"],
                "dep": dates["dep"],
                "ret": dates["ret"],
                "label": dates["label"]
            })
    
    print(f"Checking {len(routes)} strategic routes")
    print(f"Expected time: ~{len(routes) * 15} seconds (~{len(routes) * 15 // 60 + 1} min)")
    print()
    
    results = []
    
    for i, route in enumerate(routes, 1):
        print(f"\n[{i}/{len(routes)}] {route['fromCity']} -> {route['toCity']} ({route['label']})")
        
        result = await get_real_price(
            route['from'],
            route['fromCity'],
            route['to'],
            route['toCity'],
            route['dep'],
            route['ret']
        )
        
        results.append(result)
    
    print("\n" + "=" * 70)
    print("RESULTS - SORTED BY PRICE")
    print("=" * 70)
    print()
    
    # Filter and sort
    valid_results = [r for r in results if r['price']]
    valid_results.sort(key=lambda x: x['price'])
    
    if valid_results:
        print(f"Found {len(valid_results)} flights with prices:\n")
        
        for i, result in enumerate(valid_results, 1):
            print(f"{i}. CHF {result['price']:4} | {result['fromCity']:8} -> {result['toCity']:12}")
            print(f"   Dates: {result['depDate']} to {result['retDate']}")
            print()
        
        # THE CHEAPEST
        cheapest = valid_results[0]
        print("\n" + "=" * 70)
        print("*** THE CHEAPEST OPTION FOUND ***")
        print("=" * 70)
        print()
        print(f"Price:       CHF {cheapest['price']}")
        print(f"From:        {cheapest['fromCity']} ({cheapest['fromCode']})")
        print(f"To:          {cheapest['toCity']} ({cheapest['toCode']})")
        print(f"Departure:   {cheapest['depDate']}")
        print(f"Return:      {cheapest['retDate']}")
        print()
        print("BOOK HERE:")
        print(f"https://www.google.com/travel/flights?q=Flights%20to%20{cheapest['toCode']}%20from%20{cheapest['fromCode']}%20on%20{cheapest['depDate']}%20through%20{cheapest['retDate']}")
        print()
        
    else:
        print("[WARN] No prices found")
    
    # Save results
    with open('fast-search-results.json', 'w') as f:
        json.dump({
            "searchDate": datetime.now().isoformat(),
            "totalSearches": len(routes),
            "foundPrices": len(valid_results),
            "cheapest": valid_results[0] if valid_results else None,
            "allResults": results
        }, f, indent=2)
    
    print("Results saved: fast-search-results.json")
    print()

if __name__ == "__main__":
    asyncio.run(main())
