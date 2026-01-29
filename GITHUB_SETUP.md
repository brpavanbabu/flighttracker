# 🚀 GitHub Actions Setup - 100% FREE Automation

## ✅ **What This Does:**

- ✅ Automatically updates prices **daily at 22:00 (10 PM)**
- ✅ Calls your Vercel API
- ✅ Gets real prices from Amadeus
- ✅ **100% FREE** (no paid plans needed!)

---

## 📋 **Setup Steps (5 Minutes):**

### **Step 1: Initialize Git Repository**

```powershell
# Initialize git
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Flight tracker with Amadeus API"
```

---

### **Step 2: Create GitHub Repository**

1. Go to: https://github.com/new
2. **Repository name**: `flight-tracker-switzerland-india`
3. **Visibility**: Public (or Private - your choice)
4. **DON'T** initialize with README (we already have files)
5. Click **"Create repository"**

---

### **Step 3: Push to GitHub**

GitHub will show you commands like this:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/flight-tracker-switzerland-india.git
git branch -M main
git push -u origin main
```

**Copy and run those commands in PowerShell!**

---

### **Step 4: GitHub Actions Will Auto-Run!**

Once pushed, GitHub Actions will:
- ✅ Automatically detect `.github/workflows/update-prices.yml`
- ✅ Schedule daily runs at 22:00
- ✅ Start working immediately!

---

## 🧪 **Test It Manually:**

### **In GitHub:**

1. Go to your repository
2. Click **"Actions"** tab
3. Click **"Update Flight Prices Daily"**
4. Click **"Run workflow"** → **"Run workflow"**
5. Watch it run in real-time!

You should see:
```
✅ Successfully updated prices!
🏆 Cheapest flight: Delhi at CHF 450
```

---

## 📊 **Monitor Your Automation:**

### **View Workflow Runs:**
```
https://github.com/YOUR_USERNAME/flight-tracker-switzerland-india/actions
```

You'll see:
- ✅ Daily runs at 22:00
- 📊 Success/failure status
- 📝 Detailed logs
- 💰 Execution time (should be ~10-15 seconds)

---

## 🎯 **Schedule Details:**

### **Current Schedule:**
```yaml
cron: '0 22 * * *'
```

**Means:** Every day at 22:00 UTC (10 PM)

### **Change Schedule?**

Edit `.github/workflows/update-prices.yml`:

```yaml
# Every 6 hours:
cron: '0 */6 * * *'

# Twice daily (8 AM and 8 PM):
cron: '0 8,20 * * *'

# Every Monday at 9 AM:
cron: '0 9 * * 1'
```

**Cron format:** `minute hour day month weekday`

Use: https://crontab.guru/ to help create schedules

---

## 💰 **Cost Breakdown:**

| Service | Cost |
|---------|------|
| GitHub Actions | **FREE** (2,000 min/month) |
| Vercel Hosting | **FREE** |
| Vercel Functions | **FREE** (100GB-hours/month) |
| Amadeus API | **FREE** (2,000 calls/month) |
| **TOTAL** | **$0.00** ✅ |

**No credit card needed. No paid plans. 100% free!**

---

## 🔧 **How It Works:**

```
GitHub Actions (22:00 daily)
      ↓
Calls: https://flight-tracker-switzerland-bangalor.vercel.app/api/get-flight-prices
      ↓
Vercel API calls Amadeus
      ↓
Gets real prices
      ↓
Website auto-updates
      ↓
Users see live prices!
```

---

## 🐛 **Troubleshooting:**

### **Workflow not running?**

**Check:**
1. Go to: Settings → Actions → General
2. Make sure **"Allow all actions"** is selected
3. Scroll to **"Workflow permissions"**
4. Select **"Read and write permissions"**
5. Click **"Save"**

### **API call failing?**

**Check Vercel environment variables:**
- `AMADEUS_API_KEY` is set
- `AMADEUS_API_SECRET` is set
- Both are in **Production** environment

### **Want email notifications?**

Add this to the workflow:

```yaml
- name: Send email
  uses: dawidd6/action-send-mail@v3
  with:
    server_address: smtp.gmail.com
    server_port: 465
    username: ${{secrets.EMAIL_USERNAME}}
    password: ${{secrets.EMAIL_PASSWORD}}
    subject: Flight Prices Updated!
    body: Cheapest flight found at CHF ${{ steps.update.outputs.price }}
    to: your-email@example.com
    from: GitHub Actions
```

---

## 📱 **Add Slack/Discord Notifications?**

### **For Slack:**

```yaml
- name: Slack notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: 'Flight prices updated! Check https://flight-tracker-switzerland-bangalor.vercel.app'
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### **For Discord:**

```yaml
- name: Discord notification
  uses: tsickert/discord-webhook@v5.3.0
  with:
    webhook-url: ${{ secrets.DISCORD_WEBHOOK }}
    content: "Flight prices updated! 🚀"
```

---

## ✅ **Summary:**

Once you push to GitHub:
- ✅ Daily updates at 22:00 (10 PM)
- ✅ Real prices from Amadeus
- ✅ Automatic monitoring
- ✅ View logs in GitHub Actions
- ✅ **100% FREE**
- ✅ No manual work

---

## 🚀 **Quick Commands:**

```powershell
# Initialize and push to GitHub:
git init
git add .
git commit -m "Flight tracker with FREE daily updates"
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main

# Done! GitHub Actions will handle the rest!
```

---

## 📞 **Resources:**

- **GitHub Actions Docs**: https://docs.github.com/en/actions
- **Cron Helper**: https://crontab.guru/
- **Your Workflow**: `.github/workflows/update-prices.yml`

---

**Your flight tracker is now 100% automated and FREE! 🎉**
