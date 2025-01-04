# Initialize global task list
$global:Tasks = @(
    @{ Name = "Install Brave"; Selected = $false; Action = { winget install -e --id Brave.Brave } },
    @{ Name = "Install SpotX"; Selected = $false; Action = { iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify" } },
    @{ Name = "Install VSC & Github"; Selected = $false; Action = { winget install -e --id Microsoft.VisualStudioCode; winget install -e --id GitHub.GitHubDesktop } }
@{
    Name = "Activate Microsoft Windows 10 || 11";
    Selected = $false; 
    Action = { 
            $cmdUrl = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/refs/heads/master/MAS/Separate-Files-Version/Activators/Online_KMS_Activation.cmd';
            $tempFile = "$env:TEMP\Online_KMS_Activation.cmd";
            Invoke-RestMethod -Uri $cmdUrl -OutFile $tempFile;
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c $tempFile /K-Windows" -Wait;
            Remove-Item -Path $tempFile -Force;
    }
}
@{
    Name = "Activate MS OFFICE"; 
    Selected = $false; 
    Action = { 
            $cmdUrl = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/refs/heads/master/MAS/Separate-Files-Version/Activators/Online_KMS_Activation.cmd';
            $tempFile = "$env:TEMP\Online_KMS_Activation.cmd";
            Invoke-RestMethod -Uri $cmdUrl -OutFile $tempFile;
            Start-Process -FilePath "cmd.exe" -ArgumentList "/c $tempFile /K-Office" -Wait;
            Remove-Item -Path $tempFile -Force;
    }
}
)

# Function to reset all tasks to off (optional if everything starts as $false)
function Reset-Tasks {
    foreach ($task in $global:Tasks) {
        $task.Selected = $false
    }
}

# Function to display the menu
function Display-Menu {
    Clear-Host
    # Menu Header
    Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                      MAIN MENU                     ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""

    # Displaying tasks in a fancy format
    for ($i = 0; $i -lt $global:Tasks.Count; $i++) {
        $task = $global:Tasks[$i]
        $status = if ($task.Selected) { "[✔]" } else { "[ ]" }
        Write-Host "$($i + 1)) $status $($task.Name)" -ForegroundColor Yellow
    }

    # Menu Footer
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║ Type the number to toggle a task                   ║" -ForegroundColor Cyan
    Write-Host "║ Type 'START' to execute selected tasks             ║" -ForegroundColor Cyan
    Write-Host "║ Type 'EXIT' to quit                                ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}


# Function to execute all selected tasks
function Execute-Tasks {
    Write-Host "Executing selected tasks..." -ForegroundColor Green

    foreach ($task in $global:Tasks) {
        if ($task.Selected) {
            Write-Host "Executing: $($task.Name)" -ForegroundColor Cyan
            & $task.Action
        }
    }

    Write-Host "All tasks completed!" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

# Main loop
do {
    Display-Menu
    $choice = Read-Host "Enter your choice (1-$($global:Tasks.Count), START, or EXIT)"

    if ($choice -match "^\d+$" -and [int]$choice -ge 1 -and [int]$choice -le $global:Tasks.Count) {
        $taskIndex = [int]$choice - 1
        $global:Tasks[$taskIndex].Selected = -not $global:Tasks[$taskIndex].Selected
        Write-Host "Toggled $($global:Tasks[$taskIndex].Name) to: $($global:Tasks[$taskIndex].Selected)" -ForegroundColor Yellow
    } elseif ($choice.ToUpper() -eq "START") {
        Execute-Tasks
        break
    } elseif ($choice.ToUpper() -eq "EXIT") {
        Write-Host "Exiting..." -ForegroundColor Red
        break
    } else {
        Write-Host "Invalid choice. Please try again." -ForegroundColor Red
        Start-Sleep -Milliseconds 500
    }
} while ($true)
