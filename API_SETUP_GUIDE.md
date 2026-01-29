# 🚀 Flight Price API Setup - REAL Prices with Vercel Cron

## ✅ **What This Does:**

1. **Vercel Serverless Function** (`/api/get-flight-prices`)
   - Gets REAL flight prices from Amadeus API
   - Returns actual prices in CHF
   - Updates automatically

2. **Daily Cron Job**
   - Runs every day at 22:00 (10 PM)
   - Fetches latest prices
   - Updates website automatically

3. **No Manual Work**
   - Fully automated
   - Always up-to-date
   - Real prices, not estimates

---

## 📋 **Step 1: Get Amadeus API Keys (FREE)**

### Sign up for FREE Amadeus API:

1. Go to: https://developers.amadeus.com/register
2. Create account
3. Go to "My Self-Service Workspace"
4. Click "Create New App"
5. Copy:
   - **API Key** (starts with `...`)
   - **API Secret** (long string)

### Free Tier Limits:
- ✅ 2,000 API calls/month
- ✅ Enough for daily updates (30 days × 6 routes = 180 calls)
- ✅ No credit card required

---

## 📋 **Step 2: Add API Keys to Vercel**

### In your terminal:

```powershell
# Set up Vercel secrets
vercel secrets add amadeus_api_key "YOUR_API_KEY_HERE"
vercel secrets add amadeus_api_secret "YOUR_API_SECRET_HERE"
```

**Replace with your actual keys!**

---

## 📋 **Step 3: Deploy to Vercel**

```powershell
# Deploy with new API
vercel --prod
```

Your API will be available at:
```
https://your-site.vercel.app/api/get-flight-prices
```

---

## 📋 **Step 4: Test the API**

```powershell
# Test locally first
vercel dev

# Then visit:
# http://localhost:3000/api/get-flight-prices
```

### Expected Response:

```json
{
  "success": true,
  "timestamp": "2026-01-29T...",
  "results": [
    {
      "city": "Delhi",
      "code": "DEL",
      "price": 450,
      "airline": "LH",
      "bookingLink": "https://...",
      "depDate": "2026-07-01",
      "retDate": "2026-08-01"
    },
    ...
  ],
  "cheapest": {
    "city": "Delhi",
    "price": 450,
    ...
  }
}
```

---

## 🔄 **How the Cron Job Works:**

### Vercel automatically runs:
```
Every day at 22:00 (10 PM) → Calls /api/get-flight-prices
                           ↓
                    Fetches real prices from Amadeus
                           ↓
                    Website auto-updates
```

### Monitor cron jobs:
```
https://vercel.com/your-project/deployments/crons
```

---

## 📱 **Update Website to Use API**

Your `index.html` will automatically fetch from:
```javascript
fetch('/api/get-flight-prices')
  .then(res => res.json())
  .then(data => {
    // Display real prices
    console.log('Cheapest:', data.cheapest);
  });
```

---

## ⚙️ **Configuration**

### Change routes checked:
Edit `api/get-flight-prices.js`:

```javascript
const routes = [
  { from: 'ZRH', to: 'DEL', city: 'Delhi', dep: '2026-07-01', ret: '2026-08-01' },
  // Add more routes here
];
```

### Change cron schedule:
Edit `vercel.json`:

```json
"crons": [
  {
    "path": "/api/get-flight-prices",
    "schedule": "0 22 * * *"  // 10 PM daily
  }
]
```

**Cron format:** `minute hour day month weekday`
- `0 22 * * *` = 10 PM daily
- `0 */6 * * *` = Every 6 hours
- `0 8,20 * * *` = 8 AM and 8 PM

---

## 🐛 **Troubleshooting**

### "API error: 401"
- Check your API keys are correct
- Make sure secrets are set in Vercel

### "API error: 429" (Too many requests)
- You've exceeded free tier limit
- Reduce routes or upgrade plan

### Cron not running:
- Cron jobs only work on **paid Vercel plans** (Hobby: $20/month)
- Alternative: Use GitHub Actions (free)

---

## 💰 **Cost Breakdown**

### FREE:
- ✅ Vercel hosting (static site)
- ✅ Amadeus API (2,000 calls/month)
- ✅ GitHub Actions cron (if needed)

### PAID:
- ⚠️ Vercel Cron: $20/month (Hobby plan)
- Alternative: Use free GitHub Actions

---

## 🎯 **Alternative: Free Cron with GitHub Actions**

If you don't want to pay for Vercel cron:

1. Push code to GitHub
2. Create `.github/workflows/update-prices.yml`:

```yaml
name: Update Flight Prices
on:
  schedule:
    - cron: '0 22 * * *'  # 10 PM daily
  workflow_dispatch:

jobs:
  update:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Call API
        run: |
          curl https://your-site.vercel.app/api/get-flight-prices
```

---

## 📊 **Summary**

| Feature | Status |
|---------|--------|
| Real Prices | ✅ YES (Amadeus API) |
| Auto Update | ✅ YES (Cron daily) |
| No Assumptions | ✅ YES (Live data) |
| Free | ✅ Mostly (Amadeus free, Vercel cron $20/mo) |
| Mobile Friendly | ✅ YES |

---

## 🚀 **Quick Start Commands**

```powershell
# 1. Get Amadeus API keys
# Visit: https://developers.amadeus.com/register

# 2. Add secrets to Vercel
vercel secrets add amadeus_api_key "YOUR_KEY"
vercel secrets add amadeus_api_secret "YOUR_SECRET"

# 3. Deploy
vercel --prod

# 4. Test
curl https://your-site.vercel.app/api/get-flight-prices

# Done! Prices update automatically at 10 PM daily
```

---

## ✨ **Result:**

- ✅ Real prices from Amadeus
- ✅ Updates daily at 10 PM
- ✅ No manual work
- ✅ Beautiful website
- ✅ Mobile friendly
- ✅ Direct booking links

**Your website now has REAL, LIVE prices that update automatically! 🎉**
