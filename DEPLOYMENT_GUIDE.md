# 🚀 Deploy Flight Tracker to Vercel

## 📋 What Was Created

A beautiful, responsive website displaying flight prices from Switzerland to Bangalore.

**Files Created:**
- `index.html` - Main website with flight prices
- `vercel.json` - Vercel configuration
- `package.json` - Project metadata

## 🌐 How to Deploy to Vercel

### Option 1: Deploy via Vercel CLI (Easiest)

#### Step 1: Install Vercel CLI
```powershell
npm install -g vercel
```

#### Step 2: Login to Vercel
```powershell
vercel login
```
This will open your browser. Sign in with:
- GitHub
- GitLab
- Email

#### Step 3: Deploy!
```powershell
# From the Maltbot directory
vercel
```

Follow the prompts:
- Set up and deploy? **Y**
- Which scope? Choose your account
- Link to existing project? **N**
- Project name? **flight-tracker** (or any name)
- Directory? **.** (press Enter)
- Override settings? **N**

#### Step 4: Deploy to Production
```powershell
vercel --prod
```

**Done!** Your site will be live at: `https://flight-tracker-xxx.vercel.app`

---

### Option 2: Deploy via Vercel Website (No CLI needed)

#### Step 1: Create Git Repository

```powershell
# Initialize git in current directory
git init

# Add files
git add index.html vercel.json package.json

# Commit
git commit -m "Initial flight tracker website"
```

#### Step 2: Push to GitHub

1. Go to https://github.com/new
2. Create new repository: `flight-tracker-switzerland-bangalore`
3. Push your code:

```powershell
git remote add origin https://github.com/YOUR_USERNAME/flight-tracker-switzerland-bangalore.git
git branch -M main
git push -u origin main
```

#### Step 3: Deploy on Vercel

1. Go to https://vercel.com
2. Sign in with GitHub
3. Click "Add New Project"
4. Import your GitHub repository
5. Click "Deploy"

**Done!** Your site will be live in ~1 minute!

---

### Option 3: Drag & Drop (Simplest, No Git)

1. Go to https://vercel.com
2. Sign in
3. Drag and drop these files into Vercel:
   - index.html
   - vercel.json
   - package.json

**Done!** Instant deployment!

---

## ✅ After Deployment

You'll get a URL like:
```
https://flight-tracker-switzerland-bangalore.vercel.app
```

### Custom Domain (Optional)

In Vercel dashboard:
1. Go to your project
2. Click "Settings" → "Domains"
3. Add your custom domain
4. Follow DNS setup instructions

---

## 🔄 Update Your Website

### Method 1: Via CLI
```powershell
# Make changes to index.html
# Then redeploy:
vercel --prod
```

### Method 2: Via Git
```powershell
# Make changes
git add .
git commit -m "Update prices"
git push

# Vercel auto-deploys from GitHub!
```

---

## 📊 Website Features

Your deployed website includes:

✅ **Beautiful Design**
- Gradient background
- Responsive layout (mobile-friendly)
- Modern card-based UI
- Smooth animations

✅ **Flight Information**
- All 4 airline options with prices
- Route details (via Istanbul, Dubai, Doha, Direct)
- Duration and stop information
- Best deal highlighted

✅ **Money-Saving Tips**
- 5 practical tips to save money
- Date adjustment suggestions
- Airport alternatives

✅ **Direct Search Links**
- Google Flights (Zurich & Geneva)
- Skyscanner
- Momondo
- One-click access to compare prices

✅ **Responsive**
- Works on desktop, tablet, mobile
- Optimized for all screen sizes

---

## 🎨 Customize Your Website

### Update Prices

Edit `index.html` and find the price cards:

```html
<div class="price">CHF 900-1,100</div>
```

Change the numbers, then redeploy.

### Change Dates

Find this section:

```html
<div class="date-value">Mid-July</div>
<small>~July 15, 2026</small>
```

Update as needed.

### Add More Airlines

Copy a price card block and modify:

```html
<div class="price-card">
    <span class="badge value">NEW OPTION</span>
    <div class="airline-name">Your Airline</div>
    <div class="price">CHF XXX-XXX</div>
    <!-- ... rest of details ... -->
</div>
```

---

## 📱 Share Your Website

Once deployed, share your Vercel URL:

- Email to family/friends
- Post on social media
- Bookmark for easy access
- Share with travel groups

---

## 🔧 Troubleshooting

### "Command not found: vercel"
```powershell
# Reinstall Vercel CLI
npm install -g vercel

# Or use npx
npx vercel
```

### Deployment Failed
- Check all 3 files exist in directory
- Make sure you're in the correct folder
- Try `vercel --prod` again

### Website Not Updating
```powershell
# Force redeploy
vercel --prod --force
```

---

## 💡 Pro Tips

1. **Set Environment Variables** (if needed later):
   ```powershell
   vercel env add BRAVE_API_KEY
   ```

2. **View Deployment Logs**:
   ```powershell
   vercel logs
   ```

3. **List All Deployments**:
   ```powershell
   vercel ls
   ```

4. **Remove Old Deployments**:
   - Go to Vercel dashboard
   - Delete unused deployments

---

## 🎯 Next Steps

After deployment:

1. ✅ Test website on mobile
2. ✅ Share URL with friends/family
3. ✅ Set up price alerts on booking sites
4. ✅ Update website when prices change
5. ✅ Add custom domain (optional)

---

## 📊 Your Live Website Will Show:

- Current best prices (CHF 900-1,500)
- All airline options
- Route details
- Money-saving tips
- Direct booking links
- Last updated timestamp

**All automated and beautifully displayed!** 🎉

---

## 🆘 Need Help?

Common commands:
```powershell
vercel --help          # Show help
vercel login          # Login
vercel                # Deploy preview
vercel --prod         # Deploy production
vercel ls             # List projects
vercel domains        # Manage domains
```

Vercel Docs: https://vercel.com/docs

---

**Your flight tracker website is ready to deploy!** 🚀
