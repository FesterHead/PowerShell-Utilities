# PowerShell Utilities

This repository contains a small set of PowerShell utilities and configuration used for the user's shell and package management.

## Contents

- Microsoft.PowerShell_profile.ps1 - Personal PowerShell profile.
- Winget-Package-Manager-Helper.ps1 - Interactive menu-driven helper script for winget (list, update, open web search helpers).

## Prerequisites

- Windows 10 / Windows 11
- PowerShell 7.5 or newer
- winget (Windows Package Manager) available in PATH

Note: The scripts enforce PowerShell 7.5 via #Requires -Version 7.5.

## Quick Start

1. Create a symbolic link from your PowerShell profile to the repository's `Microsoft.PowerShell_profile.ps1`.

Run from the repository root:

```pwsh
## 1. Set target to the repository profile script
$target = Join-Path (Get-Location) 'Microsoft.PowerShell_profile.ps1'
if (-not (Test-Path -Path $target)) {
    Write-Error "Target file '$target' does not exist. Ensure you are running this from the repository root directory (e.g. Set-Location 'E:\Projects\PowerShell-Utilities')."
} else {
    ## 2. Get profile directories for both PowerShell 7 and Windows PowerShell 5.1 (Android Studio default)
    $docsDir = [Environment]::GetFolderPath('MyDocuments')
    $profileDirs = @(
        (Join-Path $docsDir 'PowerShell'),
        (Join-Path $docsDir 'WindowsPowerShell')
    )

    ## 3. Link profile files for Console, VS Code, Android Studio, and All Hosts
    foreach ($dir in $profileDirs) {
        if (-not (Test-Path -Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        $profilesToLink = @(
            (Join-Path $dir 'Microsoft.PowerShell_profile.ps1'),
            (Join-Path $dir 'Microsoft.VSCode_profile.ps1'),
            (Join-Path $dir 'profile.ps1')
        )
        foreach ($p in $profilesToLink) {
            if (Test-Path -Path $p) { Copy-Item -Path $p -Destination "${p}.bak" -Force -ErrorAction SilentlyContinue }
            Remove-Item -Path $p -Force -ErrorAction SilentlyContinue
            New-Item -ItemType SymbolicLink -Path $p -Target $target -Force | Out-Null
        }
    }
    . $PROFILE
}
```

Notes:

- Creating symbolic links requires either running PowerShell as Administrator or enabling Developer Mode on Windows.
- Linking `$PROFILE.CurrentUserAllHosts` (`profile.ps1`) ensures your profile automatically loads across all PowerShell environments including Android Studio, VS Code, Windows Terminal, and standalone consoles.
- The preferred approach uses `Get-Location` so instructions do not contain any personal full paths (no usernames shown).

To run the winget helper script directly (assumes you are in the repository directory):

```pwsh
.\Winget-Package-Manager-Helper.ps1
```

## Usage Notes

- The Winget-Package-Manager-Helper.ps1 script provides an interactive menu to:
  - List installed winget apps
  - Check available updates and either update all or a single package by ID
  - Open web front-ends (winstall.app or winget.run) to search for packages and copy install commands

When updating or installing with winget, the helper passes `--accept-package-agreements --accept-source-agreements` for unattended installs where appropriate.

## Contributing

- Fork the repository, create a branch, and open a pull request.
- Update CHANGELOG.md (add a ## [X.Y.Z] section) for any release entries.

## License

This project is licensed under the terms in the LICENSE file.

## Changelog

See CHANGELOG.md for the full history.
