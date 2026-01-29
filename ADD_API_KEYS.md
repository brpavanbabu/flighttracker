# 🔐 Add API Keys to Vercel - Visual Guide

## ✅ **Your Website is Already Deployed!**

**Live at:** https://flight-tracker-switzerland-bangalor.vercel.app

**Now we just need to add API keys so it can fetch real prices!**

---

## 📋 **Steps (Takes 2 Minutes):**

### **STEP 1: Open Environment Variables Page**

I just opened it for you! Or go here:
```
https://vercel.com/pavans-projects-bed18760/flight-tracker-switzerland-bangalore/settings/environment-variables
```

---

### **STEP 2: Add First Variable**

Click **"Add New"** button

**Fill in:**
```
Name:        AMADEUS_API_KEY
Value:       3J8Q7GTXSrmNBiW2
Environment: Production ✓
```

Click **"Save"**

---

### **STEP 3: Add Second Variable**

Click **"Add New"** again

**Fill in:**
```
Name:        AMADEUS_API_SECRET
Value:       t1PsqMzfQPD05jAerWTni1NZ9c0IC692
Environment: Production ✓
```

Click **"Save"**

---

### **STEP 4: Redeploy**

After both variables are added:

1. Go to **"Deployments"** tab
2. Click on latest deployment
3. Click **"Redeploy"** button
4. Wait ~30 seconds

---

## ✅ **Test Your API**

After redeployment, test:

```
https://flight-tracker-switzerland-bangalor.vercel.app/api/get-flight-prices
```

You should see real flight prices in JSON format!

---

## 🎯 **What You'll Get:**

```json
{
  "success": true,
  "timestamp": "2026-01-29T...",
  "results": [
    {
      "city": "Delhi",
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

## 🎉 **Then You're DONE!**

Your flight tracker will:
- ✅ Show REAL prices (no assumptions)
- ✅ Update automatically at 22:00 daily
- ✅ Work on mobile
- ✅ Have direct booking links

---

## 📝 **Quick Copy-Paste:**

**Variable 1:**
```
AMADEUS_API_KEY
3J8Q7GTXSrmNBiW2
```

**Variable 2:**
```
AMADEUS_API_SECRET
t1PsqMzfQPD05jAerWTni1NZ9c0IC692
```

**Just copy these into Vercel dashboard!**

---

**Let me know when you've added them and I'll help test! 🚀**
