# YouTube Subscription Recommender
# Created with Moltbot - Your Personal AI Assistant

Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "🎥 YouTube Content Recommender" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: Get user's interests
Write-Host "Tell me about your YouTube interests!" -ForegroundColor Yellow
Write-Host ""
$channels = Read-Host "What are your favorite YouTube channels? (separate with commas)"
$topics = Read-Host "What topics do you like? (tech, gaming, education, etc.)"

Write-Host "`nAnalyzing your interests with AI..." -ForegroundColor Cyan

# Step 2: Use Moltbot to generate recommendations
$prompt = @"
Based on these YouTube interests:
- Favorite channels: $channels
- Topics: $topics

Please recommend:
1. 5 similar YouTube channels to check out
2. 3 trending topics in these areas
3. 2 specific video ideas to search for

Format it in a clear, organized way.
"@

Write-Host "Asking Moltbot AI for personalized recommendations..." -ForegroundColor Yellow
Write-Host ""

# Get recommendations from Moltbot
$recommendations = clawdbot agent --to +1234567890 --message $prompt --local 2>&1

# Display results
Write-Host "=====================================" -ForegroundColor Green
Write-Host "🎯 YOUR PERSONALIZED RECOMMENDATIONS" -ForegroundColor Green
Write-Host "=====================================" -ForegroundColor Green
Write-Host ""
Write-Host $recommendations

# Save to file
Write-Host "`n=====================================" -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm"
$filename = "YouTube_Recommendations_$timestamp.txt"

@"
YouTube Recommendations - Generated on $(Get-Date)
Interests: $channels | $topics

$recommendations
"@ | Out-File $filename

Write-Host "✅ Recommendations saved to: $filename" -ForegroundColor Green
Write-Host ""
Write-Host "💡 Tip: Run this script anytime you want fresh recommendations!" -ForegroundColor Yellow
Write-Host "=====================================" -ForegroundColor Cyan
