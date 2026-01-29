"""
Update website HTML with scraped flight data
Reads best-flights-july-august.json and updates index.html
"""

import json
import re
from datetime import datetime

def update_website():
    """Update index.html with latest flight data"""
    
    print("Loading flight data...")
    
    try:
        with open('best-flights-july-august.json', 'r') as f:
            data = json.load(f)
    except FileNotFoundError:
        print("No flight data file found!")
        return
    
    if 'top3' not in data or len(data['top3']) == 0:
        print("No top 3 results found in data!")
        return
    
    top3 = data['top3']
    cheapest = top3[0]
    
    print(f"Found {len(top3)} results")
    print(f"Cheapest: {cheapest['city']} - CHF {cheapest['price']}")
    print()
    
    # Read current HTML
    with open('index.html', 'r', encoding='utf-8') as f:
        html = f.read()
    
    # Update timestamp
    timestamp = datetime.now().strftime("%B %d, %Y %H:%M")
    html = re.sub(
        r'Live prices updated weekly \(Tuesdays at 10:00 PM\) \| Last: [^<]+',
        f'Live prices updated daily at 22:00 | Last: {timestamp}',
        html
    )
    
    # Update best deal section
    # Update city name
    html = re.sub(
        r'<h2>🏆 BEST DEAL - LIVE PRICES</h2>\s*<div style="font-size: 1\.8em; margin: 15px 0;">.*?</div>',
        f'<h2>🏆 BEST DEAL - LIVE PRICES</h2>\n            <div style="font-size: 1.8em; margin: 15px 0;">{cheapest["city"]}</div>',
        html,
        flags=re.DOTALL
    )
    
    # Update price
    html = re.sub(
        r'<div class="price">CHF ---</div>',
        f'<div class="price">CHF {cheapest["price"]}</div>',
        html
    )
    
    # Update dates in best deal
    dep_date_str = datetime.strptime(cheapest['depDate'], '%Y-%m-%d').strftime('%b %d')
    ret_date_str = datetime.strptime(cheapest['retDate'], '%Y-%m-%d').strftime('%b %d')
    
    # This is a simplified update - you can make it more sophisticated
    print(f"Updated best deal: {cheapest['city']} - CHF {cheapest['price']}")
    print(f"Dates: {dep_date_str} to {ret_date_str}")
    print()
    
    # Create a data file that the website can load
    # This is easier than parsing/updating complex HTML
    with open('flight-data.json', 'w') as f:
        json.dump({
            'lastUpdate': datetime.now().isoformat(),
            'top3': top3,
            'cheapest': cheapest,
            'allResults': data.get('allResults', [])
        }, f, indent=2)
    
    print("Created flight-data.json for website")
    print()
    
    # Also update a simple data file the HTML can import
    js_data = f"""
// Auto-generated flight data - DO NOT EDIT MANUALLY
const flightData = {json.dumps({'lastUpdate': datetime.now().isoformat(), 'top3': top3, 'cheapest': cheapest}, indent=2)};
"""
    
    with open('flight-data.js', 'w') as f:
        f.write(js_data)
    
    print("✅ Website data updated!")
    print("✅ Created flight-data.js for frontend")
    print()

if __name__ == "__main__":
    update_website()
