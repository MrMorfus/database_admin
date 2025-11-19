# Timer Manager for PowerShell
# Tracks multiple named timers

$script:timers = @{}

function Start-NamedTimer {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    
    if ($script:timers.ContainsKey($Name)) {
        Write-Host "Timer '$Name' is already running!" -ForegroundColor Yellow
        return
    }
    
    $script:timers[$Name] = [PSCustomObject]@{
        Name = $Name
        StartTime = Get-Date
    }
    
    Write-Host "Timer '$Name' started at $($script:timers[$Name].StartTime.ToString('HH:mm:ss'))" -ForegroundColor Green
}

function Stop-NamedTimer {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Name
    )
    
    if (-not $script:timers.ContainsKey($Name)) {
        Write-Host "Timer '$Name' not found!" -ForegroundColor Red
        return
    }
    
    $timer = $script:timers[$Name]
    $endTime = Get-Date
    $elapsed = $endTime - $timer.StartTime
    
    Write-Host "`nTimer '$Name' stopped!" -ForegroundColor Cyan
    Write-Host "Started:  $($timer.StartTime.ToString('HH:mm:ss'))" -ForegroundColor Gray
    Write-Host "Ended:    $($endTime.ToString('HH:mm:ss'))" -ForegroundColor Gray
    Write-Host "Elapsed:  $($elapsed.ToString('hh\:mm\:ss'))" -ForegroundColor Green
    
    $script:timers.Remove($Name)
}

function Show-Timers {
    if ($script:timers.Count -eq 0) {
        Write-Host "No active timers." -ForegroundColor Yellow
        return
    }
    
    Write-Host "`nActive Timers:" -ForegroundColor Cyan
    Write-Host ("=" * 60) -ForegroundColor Gray
    
    $currentTime = Get-Date
    foreach ($timer in $script:timers.Values) {
        $elapsed = $currentTime - $timer.StartTime
        Write-Host "Name:     " -NoNewline -ForegroundColor Gray
        Write-Host $timer.Name -ForegroundColor White
        Write-Host "Started:  " -NoNewline -ForegroundColor Gray
        Write-Host $timer.StartTime.ToString('HH:mm:ss') -ForegroundColor White
        Write-Host "Running:  " -NoNewline -ForegroundColor Gray
        Write-Host $elapsed.ToString('hh\:mm\:ss') -ForegroundColor Green
        Write-Host ("=" * 60) -ForegroundColor Gray
    }
}

function Clear-AllTimers {
    $script:timers.Clear()
    Write-Host "All timers cleared." -ForegroundColor Green
}

# Display usage instructions
Write-Host @"

PowerShell Timer Manager
========================

Available Commands:
  Start-NamedTimer -Name "TimerName"    Start a new timer
  Stop-NamedTimer -Name "TimerName"     Stop and display elapsed time
  Show-Timers                           Display all active timers
  Clear-AllTimers                       Clear all timers

Examples:
  Start-NamedTimer -Name "Meeting"
  Start-NamedTimer -Name "Task1"
  Show-Timers
  Stop-NamedTimer -Name "Meeting"

"@ -ForegroundColor Cyan
