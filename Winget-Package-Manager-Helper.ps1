<#
.SYNOPSIS
Winget Package Manager Helper - interactive menu for winget operations.

.DESCRIPTION
Provides a simple, interactive menu to list installed winget packages,
check and apply updates, and open web-based search helpers (winstall.app / winget.run).

.PARAMETER None
This script does not accept parameters. Run it directly or dot-source
it to import functions into your current session.

.EXAMPLE
.\Winget-Package-Manager-Helper.ps1
Runs the interactive menu in a new session.

.EXAMPLE
. .\Winget-Package-Manager-Helper.ps1
Dot-source the script to import functions into the current session.

.REQUIREMENTS
- Windows 10 or Windows 11
- `winget` (Windows Package Manager) available in PATH
- PowerShell 7.5 or newer (enforced below with `#Requires -Version 7.5`)

.NOTES
- Author: FesterHead
- Created: 2025-11-29

.LINK
https://learn.microsoft.com/windows/package-manager/winget/
#>

#Requires -Version 7.5

function Show-Menu {
    param(
        [string]$Title = "Winget Package Manager Helper"
    )
    Clear-Host
    Write-Host "=============================================="
    Write-Host " $Title"
    Write-Host "=============================================="
    Write-Host "1. List All Installed Winget Apps"
    Write-Host "2. Check and Update Apps (All or Select ID)"
    Write-Host "3. Open Web Search Helpers (winstall.app / winget.run)"
    Write-Host "4. Exit"
    Write-Host "=============================================="
}

function Get-InstalledApps {
    Write-Host "🔍 Listing all apps installed via winget..." -ForegroundColor Cyan

    # Run the winget list command and pipe to Out-Host for formatted output
    winget list --source winget

    Read-Host "Press Enter to return to the menu" | Out-Null
}

function Update-Apps {
    Write-Host "🔄 Checking for available updates (including unknown versions)..." -ForegroundColor Cyan

    # Run winget upgrade to get the list of upgradable packages
    $Upgrades = winget upgrade --include-unknown

    # Check for the "No upgradable" message
    if ($Upgrades -match 'No installed package found that is upgradable.') {
        Write-Host "✅ All installed winget packages are up-to-date!" -ForegroundColor Green
    }
    else {
        # The output is shown directly for the user to see the IDs
        $Upgrades | Out-Host

        Write-Host ""
        Write-Host "Select an update action:" -ForegroundColor Yellow
        Write-Host "  A - Update ALL apps with available upgrades"
        Write-Host "  I - Update a single app by ID (e.g., Microsoft.PowerShell)"
        Write-Host "  C - Cancel and return to menu"

        $Action = Read-Host "Enter your choice (A/I/C)"

        switch ($Action.ToUpper()) {
            "A" {
                Write-Host "🚀 Starting full upgrade. This may take a while..." -ForegroundColor Green
                winget upgrade --all --accept-package-agreements --accept-source-agreements
            }
            "I" {
                # Prompt for the ID. User can copy the ID (e.g., PeterDaveHello.TransmissionRemoteGUI) from the list above.
                $ID = Read-Host "Enter the full Package ID to update"
                if (-not [string]::IsNullOrWhiteSpace($ID)) {
                    Write-Host "🚀 Starting upgrade for ID: $ID" -ForegroundColor Green
                    winget upgrade --id $ID --accept-package-agreements --accept-source-agreements
                }
            }
            default {
                Write-Host "Action cancelled. Returning to menu." -ForegroundColor Yellow
            }
        }
    }
    Read-Host "Press Enter to return to the menu" | Out-Null
}

function Open-WebHelper {
    Write-Host "This option opens a web front-end for winget (winstall.app or winget.run)." -ForegroundColor Cyan
    Write-Host "1. Open https://winstall.app/"
    Write-Host "2. Open https://winget.run/"
    Write-Host "3. Copy both links to clipboard"
    Write-Host "4. Cancel"

    $Choice = Read-Host "Enter your choice (1-4)"

    switch ($Choice) {
        "1" {
            $url = 'https://winstall.app/'
            Start-Process $url
            Write-Host "Opened $url in your default browser." -ForegroundColor Green
        }
        "2" {
            $url = 'https://winget.run/'
            Start-Process $url
            Write-Host "Opened $url in your default browser." -ForegroundColor Green
        }
        "3" {
            $links = "https://winstall.app/`nhttps://winget.run/"
            Set-Clipboard -Value $links
            Write-Host "Both links copied to clipboard." -ForegroundColor Green
        }
        default {
            Write-Host "Cancelled or invalid choice." -ForegroundColor Yellow
        }
    }

    Read-Host "Press Enter to return to the menu" | Out-Null
}

# --- Main Program Loop ---
do {
    Show-Menu
    $Choice = Read-Host "Enter your choice (1-4)"

    switch ($Choice) {
        "1" { Get-InstalledApps }
        "2" { Update-Apps }
        "3" { Open-WebHelper }
        "4" {
            Write-Host "Pau. Have a great day! 🏄 🌈 🌴 🌺 🦄" -ForegroundColor Magenta
            exit
        }
        default {
            Write-Host "Invalid choice. Please select 1, 2, 3, or 4." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($true)
