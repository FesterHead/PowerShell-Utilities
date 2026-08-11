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
## 1. Get the directory path for the profile file
$profileDirectory = Split-Path -Parent $PROFILE

## 2. Create the directory if it doesn't already exist
if (-not (Test-Path -Path $profileDirectory)) {
    Write-Host "Creating required profile directory: $profileDirectory"
    New-Item -ItemType Directory -Path $profileDirectory -Force | Out-Null
}

## 3. Set symlink
$target = Join-Path (Get-Location) 'Microsoft.PowerShell_profile.ps1'
if (Test-Path -Path $PROFILE) { Copy-Item -Path $PROFILE -Destination "${PROFILE}.bak" -Force }
Remove-Item -Path $PROFILE -Force -ErrorAction SilentlyContinue
New-Item -ItemType SymbolicLink -Path $PROFILE -Target $target

# Reload your profile now
. $PROFILE
```

Notes:

- Creating symbolic links requires either running PowerShell as Administrator or enabling Developer Mode on Windows.
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
