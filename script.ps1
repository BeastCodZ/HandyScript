# Initialize global task list
$global:Tasks = @(
    @{ Name = "Install Brave"; Selected = $false; Action = { winget install -e --id Brave.Brave } },
    @{ Name = "Install SpotX"; Selected = $false; Action = { iex "& { $(iwr -useb 'https://raw.githubusercontent.com/SpotX-Official/spotx-official.github.io/main/run.ps1') } -confirm_uninstall_ms_spoti -confirm_spoti_recomended_over -podcasts_off -block_update_on -start_spoti -new_theme -adsections_off -lyrics_stat spotify" } },
    @{ Name = "Install VSC & Github"; Selected = $false; Action = { winget install -e --id Microsoft.VisualStudioCode; winget install -e --id GitHub.GitHubDesktop } }
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
    Write-Host "Main Menu" -ForegroundColor Cyan
    Write-Host "----------------------------------"

    for ($i = 0; $i -lt $global:Tasks.Count; $i++) {
        $task = $global:Tasks[$i]
        Write-Host "$($i + 1)) Toggle $($task.Name): $($task.Selected)" -ForegroundColor Yellow
    }

    Write-Host "----------------------------------"
    Write-Host "Type 'START' to execute selected tasks or 'EXIT' to quit."
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
