# Schedule Daily Automated Flight Price Checker
# Sets up Windows Task Scheduler to run daily

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SCHEDULE DAILY AUTOMATION" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Configuration
$scriptPath = Join-Path $PSScriptRoot "auto-update-flights.ps1"
$taskName = "FlightPriceCheckerDaily"
$time = "09:00AM"  # Default: 9 AM daily

Write-Host "This will schedule automatic daily flight price checks" -ForegroundColor Yellow
Write-Host ""
Write-Host "Current Settings:" -ForegroundColor Cyan
Write-Host "  Script: $scriptPath" -ForegroundColor White
Write-Host "  Time: $time daily" -ForegroundColor White
Write-Host ""

# Ask for custom time
$customTime = Read-Host "Enter time for daily check (e.g., 09:00AM) or press Enter for 9 AM"
if ($customTime) {
    $time = $customTime
}

Write-Host ""
Write-Host "Creating scheduled task..." -ForegroundColor Yellow

# Check if task already exists
$existingTask = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($existingTask) {
    Write-Host "Task already exists. Removing old task..." -ForegroundColor Yellow
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Create the scheduled task
$action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

$trigger = New-ScheduledTaskTrigger -Daily -At $time

$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable

$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Highest

# Register the task
try {
    Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Daily automated flight price checker and website updater"
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  SCHEDULED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Name: $taskName" -ForegroundColor Cyan
    Write-Host "Runs: Daily at $time" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "What it does:" -ForegroundColor Yellow
    Write-Host "  1. Checks flight prices" -ForegroundColor White
    Write-Host "  2. Queries AI for updates" -ForegroundColor White
    Write-Host "  3. Opens price comparison sites" -ForegroundColor White
    Write-Host "  4. Waits 30 seconds" -ForegroundColor White
    Write-Host "  5. Closes browsers automatically" -ForegroundColor White
    Write-Host "  6. Updates website" -ForegroundColor White
    Write-Host "  7. Deploys to Vercel" -ForegroundColor White
    Write-Host "  8. Logs all activities" -ForegroundColor White
    Write-Host ""
    Write-Host "To manage this task:" -ForegroundColor Cyan
    Write-Host "  - View: taskschd.msc" -ForegroundColor Gray
    Write-Host "  - Run now: .\auto-update-flights.ps1" -ForegroundColor Gray
    Write-Host "  - Disable: .\stop-daily-check.ps1" -ForegroundColor Gray
    Write-Host ""
    
} catch {
    Write-Host ""
    Write-Host "Error creating scheduled task:" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Try running PowerShell as Administrator" -ForegroundColor Yellow
    exit 1
}

# Create helper scripts
Write-Host "Creating helper scripts..." -ForegroundColor Yellow

# Stop script
$stopScript = @'
# Stop Daily Flight Price Checker

$taskName = "FlightPriceCheckerDaily"

Write-Host ""
Write-Host "Disabling daily automation..." -ForegroundColor Yellow

$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($task) {
    Disable-ScheduledTask -TaskName $taskName
    Write-Host "Task disabled successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "To re-enable, run: .\schedule-daily-check.ps1" -ForegroundColor Cyan
} else {
    Write-Host "Task not found" -ForegroundColor Red
}
Write-Host ""
'@

$stopScript | Out-File -FilePath "stop-daily-check.ps1" -Encoding UTF8

# Status script
$statusScript = @'
# Check Status of Daily Automation

$taskName = "FlightPriceCheckerDaily"

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  AUTOMATION STATUS" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$task = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue

if ($task) {
    Write-Host "Status: $($task.State)" -ForegroundColor Green
    Write-Host "Last Run: $($task.LastRunTime)" -ForegroundColor White
    Write-Host "Next Run: $($task.NextRunTime)" -ForegroundColor White
    Write-Host ""
    
    # Show recent log entries
    if (Test-Path "flight-price-log.txt") {
        Write-Host "Recent Activity:" -ForegroundColor Cyan
        Get-Content "flight-price-log.txt" -Tail 20
    }
} else {
    Write-Host "Task not found or not scheduled" -ForegroundColor Red
    Write-Host ""
    Write-Host "To schedule: .\schedule-daily-check.ps1" -ForegroundColor Yellow
}
Write-Host ""
'@

$statusScript | Out-File -FilePath "check-status.ps1" -Encoding UTF8

Write-Host "Helper scripts created:" -ForegroundColor Green
Write-Host "  - stop-daily-check.ps1" -ForegroundColor White
Write-Host "  - check-status.ps1" -ForegroundColor White
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "All set! Your automation will run daily at $time" -ForegroundColor Green
Write-Host ""
Write-Host "Test it now:" -ForegroundColor Yellow
Write-Host "  .\auto-update-flights.ps1 -TestMode" -ForegroundColor Cyan
Write-Host ""
