# Schedule Automatic Multi-City Flight Checker
# Creates Windows Task Scheduler job (like cron on Windows)

#Requires -RunAsAdministrator

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  SCHEDULE DAILY AUTO-CHECKER" -ForegroundColor Cyan
Write-Host "  (Windows Task Scheduler)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$scriptPath = Join-Path $PSScriptRoot "multi-city-flight-checker.ps1"
$taskName = "MultiCityFlightChecker"

Write-Host "This will create a scheduled task to check flight prices daily" -ForegroundColor Yellow
Write-Host ""

# Get schedule preference
Write-Host "When should the checker run?" -ForegroundColor Cyan
Write-Host "1. Daily at 9:00 AM (recommended)" -ForegroundColor White
Write-Host "2. Daily at custom time" -ForegroundColor White
Write-Host "3. Multiple times per day" -ForegroundColor White
Write-Host ""

$choice = Read-Host "Enter choice (1-3)"

switch ($choice) {
    "1" {
        $triggers = @(
            $(New-ScheduledTaskTrigger -Daily -At "09:00AM")
        )
        $schedule = "Daily at 9:00 AM"
    }
    "2" {
        $time = Read-Host "Enter time (e.g., 14:30 for 2:30 PM)"
        $triggers = @(
            $(New-ScheduledTaskTrigger -Daily -At $time)
        )
        $schedule = "Daily at $time"
    }
    "3" {
        $triggers = @(
            $(New-ScheduledTaskTrigger -Daily -At "09:00AM")
            $(New-ScheduledTaskTrigger -Daily -At "15:00")
            $(New-ScheduledTaskTrigger -Daily -At "21:00")
        )
        $schedule = "3 times daily (9 AM, 3 PM, 9 PM)"
    }
    default {
        $triggers = @(
            $(New-ScheduledTaskTrigger -Daily -At "09:00AM")
        )
        $schedule = "Daily at 9:00 AM (default)"
    }
}

Write-Host ""
Write-Host "Creating scheduled task..." -ForegroundColor Yellow

# Remove existing task if present
$existing = Get-ScheduledTask -TaskName $taskName -ErrorAction SilentlyContinue
if ($existing) {
    Write-Host "Removing old task..." -ForegroundColor Gray
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# Create task action
$action = New-ScheduledTaskAction `
    -Execute "PowerShell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`"" `
    -WorkingDirectory $PSScriptRoot

# Task settings
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RunOnlyIfNetworkAvailable `
    -ExecutionTimeLimit (New-TimeSpan -Minutes 30)

# Principal
$principal = New-ScheduledTaskPrincipal `
    -UserId "$env:USERDOMAIN\$env:USERNAME" `
    -LogonType Interactive `
    -RunLevel Highest

# Register task
try {
    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $action `
        -Trigger $triggers `
        -Settings $settings `
        -Principal $principal `
        -Description "Automated multi-city flight price checker for Switzerland to India routes. Checks Mumbai, Bangalore, Hyderabad, and Andhra cities. Updates website automatically." | Out-Null
    
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  SCHEDULED SUCCESSFULLY!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Task Name: $taskName" -ForegroundColor Cyan
    Write-Host "Schedule: $schedule" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "What it does:" -ForegroundColor Yellow
    Write-Host "  1. Checks prices for:" -ForegroundColor White
    Write-Host "     - Mumbai (BOM)" -ForegroundColor Gray
    Write-Host "     - Bangalore (BLR)" -ForegroundColor Gray
    Write-Host "     - Hyderabad (HYD)" -ForegroundColor Gray
    Write-Host "     - Vijayawada (VGA)" -ForegroundColor Gray
    Write-Host "     - Visakhapatnam (VTZ)" -ForegroundColor Gray
    Write-Host "     - Chennai (MAA)" -ForegroundColor Gray
    Write-Host "     - Delhi (DEL)" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  2. Compares July-August dates" -ForegroundColor White
    Write-Host "  3. Finds cheapest options" -ForegroundColor White
    Write-Host "  4. Updates website" -ForegroundColor White
    Write-Host "  5. Deploys to Vercel" -ForegroundColor White
    Write-Host "  6. Logs all results" -ForegroundColor White
    Write-Host ""
    Write-Host "Manage Task:" -ForegroundColor Cyan
    Write-Host "  View in Task Scheduler:" -ForegroundColor White
    Write-Host "    taskschd.msc" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Run manually now:" -ForegroundColor White
    Write-Host "    .\multi-city-flight-checker.ps1" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Check status:" -ForegroundColor White
    Write-Host "    Get-ScheduledTask -TaskName $taskName" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Disable:" -ForegroundColor White
    Write-Host "    Disable-ScheduledTask -TaskName $taskName" -ForegroundColor Gray
    Write-Host ""
    Write-Host "  Remove:" -ForegroundColor White
    Write-Host "    Unregister-ScheduledTask -TaskName $taskName" -ForegroundColor Gray
    Write-Host ""
    
    # Test run option
    Write-Host "========================================" -ForegroundColor Yellow
    $testNow = Read-Host "Run a test now? (Y/N)"
    
    if ($testNow -eq "Y" -or $testNow -eq "y") {
        Write-Host ""
        Write-Host "Running test..." -ForegroundColor Cyan
        & $scriptPath -TestMode
    }
    
} catch {
    Write-Host ""
    Write-Host "ERROR: Failed to create scheduled task" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Make sure you ran PowerShell as Administrator" -ForegroundColor Yellow
    Write-Host "Right-click PowerShell -> Run as Administrator" -ForegroundColor Yellow
    Write-Host ""
    exit 1
}

Write-Host ""
Write-Host "All set! Your automation is active." -ForegroundColor Green
Write-Host "Next check: $schedule" -ForegroundColor Cyan
Write-Host ""
