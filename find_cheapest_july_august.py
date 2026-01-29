"""
COMPREHENSIVE FLIGHT SEARCH
Find THE cheapest flight from ANY Swiss city to ANY Indian city
Depart: Anytime in July 2026
Return: Anytime in August 2026
NO ASSUMPTIONS - ONLY REAL PRICES
"""

import asyncio
from playwright.async_api import async_playwright
import json
from datetime import datetime
import re

async def get_real_price(from_code, from_city, to_code, to_city, dep_date, ret_date):
    """Get REAL price from Google Flights - NO assumptions"""
    
    async with async_playwright() as p:
        print(f"  Checking {from_city} -> {to_city}...")
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        try:
            # Build Google Flights URL
            url = f"https://www.google.com/travel/flights?q=Flights%20to%20{to_code}%20from%20{from_code}%20on%20{dep_date}%20through%20{ret_date}&curr=CHF"
            
            await page.goto(url, wait_until="networkidle", timeout=60000)
            await page.wait_for_timeout(8000)
            
            price = None
            
            # Try to find price
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
                "source": "Google Flights",
                "timestamp": datetime.now().isoformat()
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
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }

async def main():
    """Find THE cheapest option across all combinations"""
    
    print()
    print("=" * 70)
    print("COMPREHENSIVE SEARCH: THE CHEAPEST FLIGHT")
    print("From: ANY Swiss Airport (Zurich/Geneva/Basel)")
    print("To: ANY Indian City")
    print("Depart: Anytime in July 2026")
    print("Return: Anytime in August 2026")
    print("=" * 70)
    print()
    
    # Swiss airports
    swiss_airports = [
        {"code": "ZRH", "city": "Zurich"},
        {"code": "GVA", "city": "Geneva"},
        {"code": "BSL", "city": "Basel"},
    ]
    
    # Indian cities
    indian_cities = [
        {"code": "DEL", "city": "Delhi"},
        {"code": "BOM", "city": "Mumbai"},
        {"code": "BLR", "city": "Bangalore"},
        {"code": "MAA", "city": "Chennai"},
        {"code": "HYD", "city": "Hyderabad"},
    ]
    
    # Date combinations (best value dates)
    date_combos = [
        {"dep": "2026-07-01", "ret": "2026-08-01", "label": "Jul 1 - Aug 1"},
        {"dep": "2026-07-07", "ret": "2026-08-04", "label": "Jul 7 - Aug 4 (Tue-Tue)"},
        {"dep": "2026-07-14", "ret": "2026-08-14", "label": "Jul 14 - Aug 14"},
    ]
    
    results = []
    total_searches = len(swiss_airports) * len(indian_cities) * len(date_combos)
    current = 0
    
    print(f"Total searches: {total_searches}")
    print(f"Expected time: ~{total_searches * 15} seconds ({total_searches * 15 // 60} min)")
    print()
    
    for dates in date_combos:
        print(f"\n{'='*70}")
        print(f"CHECKING: {dates['label']}")
        print(f"{'='*70}\n")
        
        for swiss in swiss_airports:
            for indian in indian_cities:
                current += 1
                print(f"[{current}/{total_searches}] {swiss['city']} -> {indian['city']}")
                
                result = await get_real_price(
                    swiss['code'],
                    swiss['city'],
                    indian['code'],
                    indian['city'],
                    dates['dep'],
                    dates['ret']
                )
                
                results.append(result)
                print()
    
    print("\n" + "=" * 70)
    print("RESULTS - SORTED BY PRICE (CHEAPEST FIRST)")
    print("=" * 70)
    print()
    
    # Filter and sort by price
    valid_results = [r for r in results if r['price']]
    valid_results.sort(key=lambda x: x['price'])
    
    if valid_results:
        print(f"Found {len(valid_results)} flights with prices:\n")
        
        for i, result in enumerate(valid_results[:10], 1):  # Top 10
            print(f"{i}. CHF {result['price']:4} | {result['fromCity']:8} -> {result['toCity']:12}")
            print(f"   Dates: {result['depDate']} to {result['retDate']}")
            print()
        
        # THE CHEAPEST
        cheapest = valid_results[0]
        print("\n" + "=" * 70)
        print("*** THE ABSOLUTE CHEAPEST OPTION ***")
        print("=" * 70)
        print()
        print(f"Price:       CHF {cheapest['price']}")
        print(f"From:        {cheapest['fromCity']} ({cheapest['fromCode']})")
        print(f"To:          {cheapest['toCity']} ({cheapest['toCode']})")
        print(f"Departure:   {cheapest['depDate']}")
        print(f"Return:      {cheapest['retDate']}")
        print(f"Source:      {cheapest['source']}")
        print()
        
    else:
        print("[WARN] No prices found in any search")
        print("This may be due to:")
        print("  - Google Flights requiring CAPTCHA")
        print("  - Network issues")
        print("  - Rate limiting")
        print()
    
    # Save all results
    output_file = f'comprehensive-search-{datetime.now().strftime("%Y%m%d-%H%M%S")}.json'
    with open(output_file, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"All results saved: {output_file}")
    
    # Save latest
    with open('cheapest-july-august-latest.json', 'w') as f:
        json.dump({
            "searchDate": datetime.now().isoformat(),
            "totalSearches": total_searches,
            "foundPrices": len(valid_results),
            "cheapest": valid_results[0] if valid_results else None,
            "allResults": results
        }, f, indent=2)
    
    print("Latest results: cheapest-july-august-latest.json")
    print()

if __name__ == "__main__":
    asyncio.run(main())
