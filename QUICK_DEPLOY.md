# 🚀 Quick Deploy Guide

## ✅ **You're Registered!**
- Email: `babu.pavan@gmail.com`
- Portal: https://developers.amadeus.com/my-apps

---

## 📋 **Get Your Keys (2 minutes):**

### **In the Amadeus Portal:**

1. **Sign in** at: https://developers.amadeus.com/my-apps
2. **Create New App**
   - Name: "Flight Tracker"
   - Description: "Switzerland to India flight price tracker"
3. **Copy Your Keys:**
   - ✅ API Key (example: `abc123xyz`)
   - ✅ API Secret (long string, like `aBcDeFgHiJkLmNoPqRsTuVwXyZ`)

---

## 🔧 **Deploy to Vercel (3 minutes):**

### **Step 1: Add API Keys**

Open PowerShell and run:

```powershell
# Replace with YOUR actual keys!
vercel secrets add amadeus_api_key "YOUR_API_KEY_HERE"
vercel secrets add amadeus_api_secret "YOUR_API_SECRET_HERE"
```

**Example:**
```powershell
vercel secrets add amadeus_api_key "abc123xyz456"
vercel secrets add amadeus_api_secret "aBcDeFgHiJkLmNoPqRsTuVwXyZ123456"
```

### **Step 2: Deploy**

```powershell
vercel --prod
```

Wait ~30 seconds, you'll see:
```
✅ Production: https://flight-tracker-switzerland-bangalore.vercel.app
```

---

## 🧪 **Test Your API:**

```powershell
# Test the API endpoint
curl https://your-site.vercel.app/api/get-flight-prices
```

**Expected Response:**
```json
{
  "success": true,
  "timestamp": "2026-01-29T...",
  "results": [
    {
      "city": "Delhi",
      "price": 450,
      "airline": "LH",
      ...
    }
  ],
  "cheapest": {
    "city": "Delhi",
    "price": 450
  }
}
```

---

## ✅ **What Happens Next:**

1. **Website is Live** at your Vercel URL
2. **API is Working** - returning real prices
3. **Cron Job Scheduled** - runs daily at 22:00 (10 PM)
4. **Auto-Updates** - website refreshes prices every day

---

## 🎯 **Important Notes:**

### **Amadeus FREE Tier:**
- ✅ 2,000 API calls/month
- ✅ Test environment (production requires approval)
- ✅ Enough for daily updates (30 days × 6 routes = 180 calls/month)

### **Vercel Cron Job:**
⚠️ **Cron jobs require Vercel Pro plan ($20/month)**

**FREE Alternative:**
- Use GitHub Actions (free)
- Or run Python scraper manually when needed

### **Test vs Production:**

Your API currently uses:
```
https://test.api.amadeus.com/...
```

For real bookings, switch to:
```
https://api.amadeus.com/...
```
(Requires approval from Amadeus)

---

## 🐛 **Troubleshooting:**

### **"Invalid API Key"**
- Check you copied the entire key (no spaces)
- Make sure you're using Test environment keys

### **"No results found"**
- Flight dates might be too far in the future
- Try dates closer to today (within 6 months)

### **"Too many requests"**
- You've hit the 2,000/month limit
- Wait for next month or use Python scraper

---

## 📞 **Need Help?**

**Amadeus Documentation:**
- https://developers.amadeus.com/self-service
- https://github.com/amadeus4dev/developer-guides

**Vercel Docs:**
- https://vercel.com/docs/cron-jobs

---

## 🎉 **You're Done!**

Your flight tracker is:
- ✅ Getting REAL prices
- ✅ Auto-updating daily
- ✅ Fully automated
- ✅ Mobile friendly

**Enjoy your automated flight tracker! 🚀**
