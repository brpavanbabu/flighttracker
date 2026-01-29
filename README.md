# ✈️ Flight Price Tracker | Switzerland → India

**Automated flight price tracking with REAL live prices from Amadeus API**

🌐 **Live Website:** https://flight-tracker-switzerland-bangalor.vercel.app

---

## 🎯 Features

- ✅ **Real Live Prices** from Amadeus Flight API (not estimates!)
- ✅ **Automated Daily Updates** at 22:00 (10 PM) via GitHub Actions
- ✅ **Beautiful Mobile-Friendly UI** with airline branding
- ✅ **Direct Booking Links** for each destination
- ✅ **Multiple Indian Cities** (Delhi, Mumbai, Bangalore, Chennai, Hyderabad, etc.)
- ✅ **July-August 2026** optimized dates
- ✅ **100% FREE** - No paid services required!

---

## 🚀 How It Works

```
GitHub Actions (Daily at 22:00)
        ↓
Triggers Vercel Serverless Function
        ↓
Calls Amadeus Flight Offers API
        ↓
Gets Real Prices in CHF
        ↓
Website Auto-Updates
        ↓
Users See Live Prices!
```

---

## 💰 Cost: $0.00

| Service | Plan | Cost |
|---------|------|------|
| Amadeus API | Free Tier (2,000 calls/month) | **FREE** |
| Vercel Hosting | Hobby Plan | **FREE** |
| Vercel Functions | Hobby Plan (100GB-hours) | **FREE** |
| GitHub Actions | Free (2,000 min/month) | **FREE** |
| **TOTAL** | | **$0.00** |

---

## 📋 Tech Stack

### **Frontend:**
- HTML5, CSS3, JavaScript
- Responsive design with mobile-first approach
- Real-time API data fetching

### **Backend:**
- Vercel Serverless Functions (Node.js)
- Amadeus Flight Offers API
- RESTful API architecture

### **Automation:**
- GitHub Actions for daily updates
- YAML workflow configuration
- Automated cron scheduling

---

## 🛠️ Setup

### **Prerequisites:**
- Amadeus API account (free at https://developers.amadeus.com/)
- Vercel account (free at https://vercel.com/)
- GitHub account (free at https://github.com/)

### **Quick Start:**

```bash
# 1. Clone repository
git clone https://github.com/YOUR_USERNAME/flight-tracker-switzerland-india.git
cd flight-tracker-switzerland-india

# 2. Add Amadeus API keys to Vercel
# Go to Vercel Dashboard → Your Project → Settings → Environment Variables
# Add:
#   AMADEUS_API_KEY = your_api_key
#   AMADEUS_API_SECRET = your_api_secret

# 3. Deploy to Vercel
vercel --prod

# 4. Push to GitHub (for automated updates)
git push origin main

# Done! GitHub Actions will handle daily updates automatically.
```

---

## 📖 Documentation

- **[GITHUB_SETUP.md](GITHUB_SETUP.md)** - Complete GitHub Actions setup guide
- **[API_SETUP_GUIDE.md](API_SETUP_GUIDE.md)** - Amadeus API configuration
- **[COMPLETE_SOLUTION.md](COMPLETE_SOLUTION.md)** - Full system architecture
- **[QUICK_DEPLOY.md](QUICK_DEPLOY.md)** - Quick deployment guide

---

## 🔧 Configuration

### **Change Update Schedule:**

Edit `.github/workflows/update-prices.yml`:

```yaml
schedule:
  - cron: '0 22 * * *'  # Daily at 22:00 UTC
```

**Use [crontab.guru](https://crontab.guru/) to customize the schedule.**

### **Change Routes:**

Edit `api/get-flight-prices.js`:

```javascript
const routes = [
  { from: 'ZRH', to: 'DEL', city: 'Delhi', dep: '2026-07-01', ret: '2026-08-01' },
  // Add more routes here
];
```

---

## 🌐 API Endpoints

### **Get Flight Prices:**
```
GET https://flight-tracker-switzerland-bangalor.vercel.app/api/get-flight-prices
```

**Response:**
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
    }
  ],
  "cheapest": {
    "city": "Delhi",
    "price": 450,
    ...
  }
}
```

---

## 📊 Features Breakdown

### **Frontend Features:**
- 🎨 Modern gradient design
- 📱 Mobile-responsive (works on all devices)
- ✈️ Airline branding with country flags
- ⭐ Airline ratings and details
- 🔗 Direct booking links
- 🏆 "Best Deal" banner
- 📊 Price comparison table
- 🌐 Airport information links

### **Backend Features:**
- 🔄 OAuth2 authentication with Amadeus
- 💾 Token caching for performance
- 🛡️ Error handling and validation
- 📝 Detailed logging
- ⚡ Fast serverless execution
- 🌍 CORS enabled

### **Automation Features:**
- ⏰ Daily scheduled updates
- 📧 Optional email notifications
- 📱 Optional Slack/Discord webhooks
- 📊 Workflow monitoring
- 🔔 Success/failure alerts

---

## 🧪 Testing

### **Test Locally:**
```bash
vercel dev
# Visit: http://localhost:3000
```

### **Test API:**
```bash
curl https://flight-tracker-switzerland-bangalor.vercel.app/api/get-flight-prices
```

### **Trigger Workflow Manually:**
1. Go to GitHub Actions tab
2. Select "Update Flight Prices Daily"
3. Click "Run workflow"

---

## 📈 Monitoring

### **View Logs:**
- **Vercel**: https://vercel.com/your-project/deployments
- **GitHub Actions**: https://github.com/YOUR_USERNAME/YOUR_REPO/actions

### **Check Status:**
- Website status: Visit live URL
- API status: Call `/api/get-flight-prices`
- Workflow status: Check GitHub Actions tab

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

---

## 📄 License

MIT License - feel free to use for personal or commercial projects!

---

## 🙏 Acknowledgments

- **Amadeus for Developers** - For providing the Flight Offers API
- **Vercel** - For serverless hosting and functions
- **GitHub** - For free Actions automation

---

## 📞 Support

- **Issues**: https://github.com/YOUR_USERNAME/YOUR_REPO/issues
- **Amadeus Docs**: https://developers.amadeus.com/self-service
- **Vercel Docs**: https://vercel.com/docs

---

## 🎉 Live Demo

**Visit:** https://flight-tracker-switzerland-bangalor.vercel.app

**Features:**
- View real-time flight prices
- Compare multiple destinations
- Direct booking links
- Mobile-friendly interface
- Auto-updates daily

---

**Built with ❤️ for travelers seeking the best deals on Switzerland to India flights**

---

## 🔮 Future Enhancements

- [ ] Add price history charts
- [ ] Email price alerts
- [ ] More Swiss departure cities
- [ ] More Indian destinations
- [ ] Multi-currency support
- [ ] Price prediction ML model
- [ ] Browser extension

---

**Star ⭐ this repository if you find it useful!**
