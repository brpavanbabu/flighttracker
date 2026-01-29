/**
 * Simple test endpoint to check if environment variables are set
 */

export default async function handler(req, res) {
  return res.status(200).json({
    hasApiKey: !!process.env.AMADEUS_API_KEY,
    hasApiSecret: !!process.env.AMADEUS_API_SECRET,
    apiKeyLength: process.env.AMADEUS_API_KEY ? process.env.AMADEUS_API_KEY.length : 0,
    apiSecretLength: process.env.AMADEUS_API_SECRET ? process.env.AMADEUS_API_SECRET.length : 0,
    apiKeyPreview: process.env.AMADEUS_API_KEY ? process.env.AMADEUS_API_KEY.substring(0, 5) + '...' : 'NOT SET',
  });
}
