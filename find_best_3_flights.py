"""
Smart Flight Finder - Automatically finds TOP 3 cheapest options
Searches all July-August combinations and both 2-week & 4-week durations
"""

import asyncio
from playwright.async_api import async_playwright
import json
from datetime import datetime, timedelta
import re

async def get_real_price(from_code, to_code, dep_date, ret_date, city_name):
    """Get REAL price from Google Flights"""
    
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        try:
            url = f"https://www.google.com/travel/flights?q=Flights%20to%20{to_code}%20from%20{from_code}%20on%20{dep_date}%20through%20{ret_date}&curr=CHF"
            
            await page.goto(url, wait_until="networkidle", timeout=60000)
            await page.wait_for_timeout(8000)
            
            price = None
            airline = None
            
            # Find price
            price_elements = await page.query_selector_all('text=/CHF/')
            for element in price_elements:
                text = await element.inner_text()
                match = re.search(r'CHF\s*([0-9,]+)', text)
                if match:
                    price_str = match.group(1).replace(',', '')
                    try:
                        price_val = int(price_str)
                        if 200 < price_val < 5000:
                            price = price_val
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
                    "duration": (datetime.strptime(ret_date, "%Y-%m-%d") - datetime.strptime(dep_date, "%Y-%m-%d")).days,
                    "method": "LIVE"
                }
            return None
                
        except Exception as e:
            await browser.close()
            return None

async def main():
    """Find TOP 3 cheapest flights automatically"""
    
    print()
    print("=" * 70)
    print("SMART FLIGHT FINDER - TOP 3 CHEAPEST")
    print("Switzerland to India | July-August 2026")
    print("Checking all dates & durations automatically...")
    print("=" * 70)
    print()
    
    # Cities to check
    cities = [
        {"code": "DEL", "name": "Delhi"},
        {"code": "BOM", "name": "Mumbai"},
        {"code": "BLR", "name": "Bangalore"},
        {"code": "HYD", "name": "Hyderabad"},
        {"code": "MAA", "name": "Chennai"},
    ]
    
    # Date ranges to check (July 1 - August 31)
    # Check early, mid, late July with both 2-week and 4-week durations
    searches = [
        # 2-week trips
        {"dep": "2026-07-01", "ret": "2026-07-15", "label": "Early Jul (2 weeks)"},
        {"dep": "2026-07-07", "ret": "2026-07-21", "label": "Jul 7-21 (2 weeks)"},
        {"dep": "2026-07-14", "ret": "2026-07-28", "label": "Mid Jul (2 weeks)"},
        {"dep": "2026-07-21", "ret": "2026-08-04", "label": "Late Jul (2 weeks)"},
        
        # 4-week trips
        {"dep": "2026-07-01", "ret": "2026-07-29", "label": "Early-Late Jul (4 weeks)"},
        {"dep": "2026-07-07", "ret": "2026-08-04", "label": "Jul 7 - Aug 4 (4 weeks)"},
        {"dep": "2026-07-14", "ret": "2026-08-11", "label": "Mid Jul - Mid Aug (4 weeks)"},
    ]
    
    all_results = []
    total_searches = len(cities) * len(searches)
    current = 0
    
    print(f"Searching {total_searches} combinations...")
    print(f"Expected time: ~{total_searches * 15} seconds ({total_searches * 15 // 60} min)")
    print()
    
    for search in searches:
        print(f"\n--- {search['label']} ---")
        
        for city in cities:
            current += 1
            print(f"[{current}/{total_searches}] {city['name']}... ", end='', flush=True)
            
            result = await get_real_price(
                "ZRH",
                city["code"],
                search["dep"],
                search["ret"],
                city["name"]
            )
            
            if result:
                all_results.append(result)
                print(f"CHF {result['price']}")
            else:
                print("No price")
    
    print("\n" + "=" * 70)
    print("ANALYSIS COMPLETE!")
    print("=" * 70)
    print()
    
    if len(all_results) == 0:
        print("No prices found. Google Flights may have blocked requests.")
        return
    
    # Sort by price and get top 3
    all_results.sort(key=lambda x: x['price'])
    top_3 = all_results[:3]
    
    print("[TOP 3 CHEAPEST OPTIONS]")
    print()
    
    for i, option in enumerate(top_3, 1):
        print(f"{i}. CHF {option['price']} - {option['city']}")
        print(f"   Dates: {option['depDate']} to {option['retDate']}")
        print(f"   Duration: {option['duration']} days")
        print(f"   Book: https://www.google.com/travel/flights?q=Flights%20to%20{option['code']}%20from%20ZRH%20on%20{option['depDate']}%20through%20{option['retDate']}")
        print()
    
    # Save results
    output = {
        "searchDate": datetime.now().isoformat(),
        "totalSearches": total_searches,
        "foundPrices": len(all_results),
        "top3": top_3,
        "allResults": all_results
    }
    
    with open('best-flights-july-august.json', 'w') as f:
        json.dump(output, f, indent=2)
    
    print(f"Full results saved: best-flights-july-august.json")
    print()
    
    return top_3

if __name__ == "__main__":
    asyncio.run(main())
