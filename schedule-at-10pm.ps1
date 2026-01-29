# Schedule Flight Checker to Run Daily at 10:00 PM
# Includes automatic deployment to Vercel

#Requires -RunAsAdministrator

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SCHEDULING DAILY AUTO-UPDATE" -ForegroundColor Cyan
Write-Host "  Every Night at 22:00 (10 PM)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Join-Path $PSScriptRoot "multi-city-flight-checker.ps1"
$taskName = "FlightTrackerDaily22PM"

if (-not (Test-Path $scriptPath)) {
    Write-Host "ERROR: multi-city-flight-checker.ps1 not found!" -ForegroundColor Red
    Write-Host "Make sure you're running this from the correct directory" -ForegroundColor Yellow
    exit 1
}

Write-Host "Setting up automatic daily updates:" -ForegroundColor Yellow
Write-Host "  - Checks all Indian cities" -ForegroundColor White
Write-Host "  - Compares airlines and prices" -ForegroundColor White
Write-Host "  - Updates website" -ForegroundColor White
Write-Host "  - Deploys to Vercel" -ForegroundColor White
Write-Host "  - Runs every night at 10:00 PM" -ForegroundColor White
Write-Host ""

# Remove existing task if present
$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Removing old scheduled task..." -ForegroundColor Gray
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

Write-Host "Creating new scheduled task..." -ForegroundColor Yellow

# Create task action
$action = New-ScheduledTaskAction `
    -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`"" `
    -WorkingDirectory $PSScriptRoot

# Trigger: Daily at 22:00 (10 PM)
$trigger = New-ScheduledTaskTrigger -Daily -At "22:00"

# Task settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 30) `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 5)

# Principal (run with highest privileges)
$principal = New-ScheduledTaskPrincipal `
    -UserId "$env:USERDOMAIN\$env:USERNAME" `
    -LogonType Interactive `
    -RunLevel Highest

# Register task
try {
    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $action `
        -Trigger $trigger `
        -Settings $settings `
        -Principal $principal `
        -Description "Automated flight price checker for Switzerland to India. Checks Mumbai, Bangalore, Hyderabad, Vijayawada, Visakhapatnam, Chennai, Delhi. Updates website and deploys to Vercel automatically every night at 10 PM." | Out-Null
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  SCHEDULED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Name: $taskName" -ForegroundColor Cyan
    Write-Host "Schedule: Daily at 22:00 (10:00 PM)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "What happens every night at 10 PM:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Script starts automatically" -ForegroundColor White
    Write-Host "  2. Queries Moltbot AI for prices" -ForegroundColor White
    Write-Host "  3. Checks 7 cities x 3 date ranges" -ForegroundColor White
    Write-Host "  4. Finds cheapest options" -ForegroundColor White
    Write-Host "  5. Updates website with new data" -ForegroundColor White
    Write-Host "  6. Deploys to Vercel (goes live)" -ForegroundColor White
    Write-Host "  7. Logs results to files" -ForegroundColor White
    Write-Host "  8. Completes and waits for next day" -ForegroundColor White
    Write-Host ""
    Write-Host "Cities checked:" -ForegroundColor Cyan
    Write-Host "  - Mumbai (BOM)" -ForegroundColor Gray
    Write-Host "  - Bangalore (BLR)" -ForegroundColor Gray
    Write-Host "  - Hyderabad (HYD)" -ForegroundColor Gray
    Write-Host "  - Vijayawada (VGA) - Andhra Pradesh" -ForegroundColor Gray
    Write-Host "  - Visakhapatnam (VTZ) - Andhra Pradesh" -ForegroundColor Gray
    Write-Host "  - Chennai (MAA)" -ForegroundColor Gray
    Write-Host "  - Delhi (DEL)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Airlines compared:" -ForegroundColor Cyan
    Write-Host "  - Turkish Airlines (via Istanbul)" -ForegroundColor Gray
    Write-Host "  - Emirates (via Dubai)" -ForegroundColor Gray
    Write-Host "  - Qatar Airways (via Doha)" -ForegroundColor Gray
    Write-Host "  - Air India (Direct)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Website:" -ForegroundColor Cyan
    Write-Host "  https://flight-tracker-switzerland-bangalor.vercel.app" -ForegroundColor White
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Manage Your Automation:" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "View task status:" -ForegroundColor White
    Write-Host "  Get-ScheduledTask -TaskName '$taskName'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Run manually now:" -ForegroundColor White
    Write-Host "  Start-ScheduledTask -TaskName '$taskName'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "View in Task Scheduler:" -ForegroundColor White
    Write-Host "  taskschd.msc" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Disable temporarily:" -ForegroundColor White
    Write-Host "  Disable-ScheduledTask -TaskName '$taskName'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Remove completely:" -ForegroundColor White
    Write-Host "  Unregister-ScheduledTask -TaskName '$taskName'" -ForegroundColor Gray
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Ask to run test
    $runNow = Read-Host "Run a test update now? (Y/N)"
    
    if ($runNow -eq "Y" -or $runNow -eq "y") {
        Write-Host ""
        Write-Host "Running test update..." -ForegroundColor Cyan
        Write-Host "This will update the website and deploy..." -ForegroundColor Yellow
        Write-Host ""
        
        Start-Sleep -Seconds 2
        & $scriptPath
        
        Write-Host ""
        Write-Host "Test complete! Check your website:" -ForegroundColor Green
        Write-Host "https://flight-tracker-switzerland-bangalor.vercel.app" -ForegroundColor Cyan
        Write-Host ""
    }
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ALL SET!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Your automation is active!" -ForegroundColor Cyan
    Write-Host "Next run: Tonight at 22:00 (10:00 PM)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "The website will auto-update every night." -ForegroundColor White
    Write-Host "Just check the URL anytime for latest prices!" -ForegroundColor White
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to create scheduled task" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "SOLUTION:" -ForegroundColor Yellow
    Write-Host "1. Close this PowerShell window" -ForegroundColor White
    Write-Host "2. Right-click PowerShell icon" -ForegroundColor White
    Write-Host "3. Click 'Run as Administrator'" -ForegroundColor White
    Write-Host "4. Run this script again" -ForegroundColor White
    Write-Host ""
    exit 1
}
