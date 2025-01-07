function Invoke-CommandAsAdmin {
    param (
        [string]$Command
    )
    $script = "powershell -Command `"$Command`""
    Start-Process -FilePath "powershell.exe" -ArgumentList "-NoProfile -ExecutionPolicy Bypass -Command `$script" -Verb RunAs -Wait
}

function Show-AsciiHeader {
    param(
        [string]$Title = "MENU",
        [ConsoleColor]$Color = "Green",
        [int]$Width = 54
    )

    Write-Host ("╔" + ("═" * ($Width)) + "╗") -ForegroundColor $Color
    
    $spacesNeeded = $Width - $Title.Length
    if ($spacesNeeded -ge 0) {
        $leftPad = [Math]::Floor($spacesNeeded / 2)
        $rightPad = $spacesNeeded - $leftPad
        $centeredTitle = (" " * $leftPad) + $Title + (" " * $rightPad)
    } else {
        $centeredTitle = $Title.Substring(0, $Width)
    }

    Write-Host ("║" + $centeredTitle + "║") -ForegroundColor $Color
    Write-Host ("╚" + ("═" * ($Width)) + "╝") -ForegroundColor $Color
    Write-Host ""
}

function Show-AsciiFooter {
    param(
        [string]$Message = "",
        [ConsoleColor]$Color = "Green",
        [int]$Width = 54
    )

    Write-Host ""
    Write-Host ("╔" + ("═" * ($Width)) + "╗") -ForegroundColor $Color
    if ($Message) {
        $spacesNeeded = $Width - $Message.Length
        if ($spacesNeeded -ge 0) {
            $leftPad = [Math]::Floor($spacesNeeded / 2)
            $rightPad = $spacesNeeded - $leftPad
            $centeredMessage = (" " * $leftPad) + $Message + (" " * $rightPad)
        } else {
            $centeredMessage = $Message.Substring(0, $Width)
        }
        Write-Host ("║" + $centeredMessage + "║") -ForegroundColor $Color
    }
    Write-Host ("╚" + ("═" * ($Width)) + "╝") -ForegroundColor $Color
    Write-Host ""
}

function Show-MenuPrompt {
    param(
        [string]$Message
    )
    return Read-Host $Message
}

########################################################
#                  Task Definitions                    #
########################################################

# Installation Menu tasks
$global:InstallTasks = @(
    @{ 
        Name = "Install Brave"; 
        Action = { winget install -e --id Brave.Brave } 
    },
    @{
        Name = "Install Visual Studio Code"; 
        Action = { winget install -e --id Microsoft.VisualStudioCode }
    },
    @{
        Name = "Install GitHub Desktop"; 
        Action = { winget install -e --id GitHub.GitHubDesktop }
    },
    @{
        Name = "Install Node.js & NPM"; 
        Action = { winget install -e --id OpenJS.NodeJS }
    },
    @{
        Name = "Install Python"; 
        Action = { winget install -e --id Python.Python.3 }
    },
    @{
        Name = "Install Docker"; 
        Action = { winget install -e --id Docker.DockerDesktop }
    }
)

function Display-InstallMenu {
    Clear-Host
    Show-AsciiHeader -Title "INSTALLATION MENU" -Color Green -Width 54
    
    for ($i = 0; $i -lt $global:InstallTasks.Count; $i++) {
        $task = $global:InstallTasks[$i]
        Write-Host "$($i + 1)) $($task.Name)" -ForegroundColor Yellow
    }

    Show-AsciiFooter -Message "Type the number to install a program | Type 'BACK' to return" -Color Green -Width 54

    do {
        $choice = Show-MenuPrompt -Message "Enter your choice (1-$($global:InstallTasks.Count) or BACK)"
        if ($choice -match "^\d+$" -and [int]$choice -ge 1 -and [int]$choice -le $global:InstallTasks.Count) {
            $taskIndex = [int]$choice - 1
            Write-Host "Installing: $($global:InstallTasks[$taskIndex].Name)" -ForegroundColor Green
            & $global:InstallTasks[$taskIndex].Action
        } elseif ($choice.ToUpper() -eq "BACK") {
            break
        } else {
            Write-Host "Invalid choice. Please try again." -ForegroundColor Red
        }
    } while ($true)
}

# Main tasks
$global:Tasks = @(
    @{ 
        Name    = "Installation Menu"; 
        Selected= $false; 
        Action  = { Display-InstallMenu } 
    },
    @{ 
        Name    = "Organize files by type"; 
        Selected= $false; 
        Action  = { 
            $path = Show-MenuPrompt -Message "Enter the directory path"
            Get-ChildItem -Path $path -File | Group-Object Extension | ForEach-Object { 
                $ext = $_.Name
                $folder = Join-Path -Path $path -ChildPath $ext
                if (-not (Test-Path -Path $folder)) { 
                    New-Item -ItemType Directory -Path $folder | Out-Null
                }
                $_.Group | Move-Item -Destination $folder 
            } 
        } 
    },
    @{ 
        Name    = "Clear Temp Files"; 
        Selected= $false; 
        Action  = { 
            Write-Host "Clearing Temp Files..." -ForegroundColor Green
            Remove-Item -Path $env:TEMP\* -Recurse -Force -ErrorAction SilentlyContinue
        } 
    },
    @{ 
        Name    = "Activate Windows"; 
        Selected= $false; 
        Action  = { 
            $cmdUrl   = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/refs/heads/master/MAS/Separate-Files-Version/Activators/Online_KMS_Activation.cmd'
            $tempFile = "$env:TEMP\Online_KMS_Activation.cmd"
            Invoke-RestMethod -Uri $cmdUrl -OutFile $tempFile
            Invoke-CommandAsAdmin -Command "cmd.exe /c $tempFile /K-Windows"
            Remove-Item -Path $tempFile -Force
        } 
    },
    @{ 
        Name    = "Activate Microsoft Office"; 
        Selected= $false; 
        Action  = {
            $cmdUrl   = 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/refs/heads/master/MAS/Separate-Files-Version/Activators/Online_KMS_Activation.cmd'
            $tempFile = "$env:TEMP\Online_KMS_Activation.cmd"
            Invoke-RestMethod -Uri $cmdUrl -OutFile $tempFile
            Invoke-CommandAsAdmin -Command "cmd.exe /c $tempFile /K-Office"
            Remove-Item -Path $tempFile -Force
        }
    },
    @{ 
        Name    = "Clean Windows Update Cache"; 
        Selected= $false; 
        Action  = {
            Write-Host "Stopping Windows Update Service..." -ForegroundColor Green
            Invoke-CommandAsAdmin -Command "Stop-Service wuauserv -Force"
            Write-Host "Deleting Windows Update cache files..." -ForegroundColor Green
            Invoke-CommandAsAdmin -Command "Remove-Item -Path 'C:\Windows\SoftwareDistribution\*' -Recurse -Force -ErrorAction SilentlyContinue"
            Write-Host "Starting Windows Update Service..." -ForegroundColor Green
            Invoke-CommandAsAdmin -Command "Start-Service wuauserv"
        }
    }
)

########################################################
#                Core Menu Functions                   #
########################################################

function Reset-Tasks {
    foreach ($task in $global:Tasks) {
        $task.Selected = $false
    }
}

function Display-Menu {
    Clear-Host
    Show-AsciiHeader -Title "MAIN MENU" -Color Green -Width 54

    for ($i = 0; $i -lt $global:Tasks.Count; $i++) {
        $task = $global:Tasks[$i]
        $status = if ($task.Selected) { "[✔]" } else { "[ ]" }
        Write-Host "$($i + 1)) $status $($task.Name)" -ForegroundColor Yellow
    }

    Show-AsciiFooter -Message "Type the number to toggle a task | START to execute | EXIT to quit" -Color Green -Width 54
}

function Execute-Tasks {
    Write-Host "Executing selected tasks..." -ForegroundColor Green

    foreach ($task in $global:Tasks) {
        if ($task.Selected) {
            Write-Host "Executing: $($task.Name)" -ForegroundColor Green
            & $task.Action
            Write-Host "Task complete: $($task.Name)" -ForegroundColor Green
        }
    }

    Write-Host "All selected tasks completed!" -ForegroundColor Green
    Start-Sleep -Seconds 2
}

########################################################
#                     Main Loop                        #
########################################################

do {
    Display-Menu
    $choice = Show-MenuPrompt -Message "Enter your choice (1-$($global:Tasks.Count), START, or EXIT)"

    if ($choice -match "^\d+$" -and [int]$choice -ge 1 -and [int]$choice -le $global:Tasks.Count) {
        $taskIndex = [int]$choice - 1
        $global:Tasks[$taskIndex].Selected = -not $global:Tasks[$taskIndex].Selected
        Write-Host "Toggled $($global:Tasks[$taskIndex].Name) to: $($global:Tasks[$taskIndex].Selected)" -ForegroundColor Yellow
        Start-Sleep -Milliseconds 500
    } 
    elseif ($choice.ToUpper() -eq "START") {
        Execute-Tasks
        break
    } 
    elseif ($choice.ToUpper() -eq "EXIT") {
        Write-Host "Exiting..." -ForegroundColor Red
        break
    } 
    else {
        Write-Host "Invalid choice. Please try again." -ForegroundColor Red
        Start-Sleep -Milliseconds 500
    }
} while ($true)
