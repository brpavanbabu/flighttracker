/**
 * Vercel Serverless Function
 * Gets REAL flight prices using Amadeus API
 * Called by: website + daily cron job
 */

const AMADEUS_API_KEY = process.env.AMADEUS_API_KEY;
const AMADEUS_API_SECRET = process.env.AMADEUS_API_SECRET;

let accessToken = null;
let tokenExpiry = null;

/**
 * Get Amadeus access token
 */
async function getAccessToken() {
  if (accessToken && tokenExpiry && Date.now() < tokenExpiry) {
    return accessToken;
  }

  const response = await fetch('https://test.api.amadeus.com/v1/security/oauth2/token', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: `grant_type=client_credentials&client_id=${AMADEUS_API_KEY}&client_secret=${AMADEUS_API_SECRET}`,
  });

  const data = await response.json();
  accessToken = data.access_token;
  tokenExpiry = Date.now() + (data.expires_in * 1000) - 60000; // 1 min buffer

  return accessToken;
}

/**
 * Search for flight prices
 */
async function searchFlights(origin, destination, departureDate, returnDate) {
  const token = await getAccessToken();

  const url = new URL('https://test.api.amadeus.com/v2/shopping/flight-offers');
  url.searchParams.append('originLocationCode', origin);
  url.searchParams.append('destinationLocationCode', destination);
  url.searchParams.append('departureDate', departureDate);
  url.searchParams.append('returnDate', returnDate);
  url.searchParams.append('adults', '1');
  url.searchParams.append('currencyCode', 'CHF');
  url.searchParams.append('max', '5');

  const response = await fetch(url, {
    headers: {
      'Authorization': `Bearer ${token}`,
    },
  });

  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }

  const data = await response.json();
  
  // Extract cheapest price
  if (data.data && data.data.length > 0) {
    const cheapest = data.data[0];
    return {
      price: parseFloat(cheapest.price.total),
      currency: cheapest.price.currency,
      airline: cheapest.validatingAirlineCodes[0],
      bookingLink: `https://www.google.com/travel/flights?q=Flights%20to%20${destination}%20from%20${origin}%20on%20${departureDate}%20through%20${returnDate}`,
    };
  }

  return null;
}

/**
 * Main handler
 */
export default async function handler(req, res) {
  // Enable CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(200).end();
  }

  try {
    // Routes to check
    // Using closer dates for testing (Amadeus API typically allows booking 6 months ahead)
    const routes = [
      { from: 'ZRH', to: 'DEL', city: 'Delhi', dep: '2026-03-15', ret: '2026-04-15' },
      { from: 'ZRH', to: 'BOM', city: 'Mumbai', dep: '2026-03-15', ret: '2026-04-15' },
      { from: 'ZRH', to: 'BLR', city: 'Bangalore', dep: '2026-03-20', ret: '2026-04-20' },
      { from: 'ZRH', to: 'MAA', city: 'Chennai', dep: '2026-03-20', ret: '2026-04-20' },
      { from: 'ZRH', to: 'HYD', city: 'Hyderabad', dep: '2026-03-25', ret: '2026-04-25' },
      { from: 'ZRH', to: 'VGA', city: 'Vijayawada', dep: '2026-03-15', ret: '2026-04-15' },
      { from: 'ZRH', to: 'VTZ', city: 'Visakhapatnam', dep: '2026-03-15', ret: '2026-04-15' },
      // Note: Smaller airports (VGA, VTZ) may not have direct flights or data available
    ];

    const results = [];

    for (const route of routes) {
      try {
        const priceData = await searchFlights(route.from, route.to, route.dep, route.ret);
        
        results.push({
          city: route.city,
          code: route.to,
          price: priceData ? priceData.price : null,
          airline: priceData ? priceData.airline : null,
          bookingLink: priceData ? priceData.bookingLink : null,
          depDate: route.dep,
          retDate: route.ret,
          timestamp: new Date().toISOString(),
        });
      } catch (error) {
        console.error(`Error for ${route.city}:`, error.message);
        results.push({
          city: route.city,
          code: route.to,
          price: null,
          error: error.message,
          depDate: route.dep,
          retDate: route.ret,
        });
      }
    }

    // Sort by price
    results.sort((a, b) => {
      if (!a.price) return 1;
      if (!b.price) return -1;
      return a.price - b.price;
    });

    return res.status(200).json({
      success: true,
      timestamp: new Date().toISOString(),
      results,
      cheapest: results.find(r => r.price) || null,
    });

  } catch (error) {
    console.error('Handler error:', error);
    return res.status(500).json({
      success: false,
      error: error.message,
    });
  }
}
