<#
.SYNOPSIS
    Upgrades all Winget packages

.DESCRIPTION
   PowerShell script to upgrade all Winget packages

.EXAMPLE
    .\Upgrade-Winget.ps1

.NOTES
    Author: Paul Gosling, Persimmon Homes
    Last Edit: 2024-10-02
#>

# Define log file path
$logFile = Join-Path $env:ProgramData "_MEM\Upgrade-Winget.log"

# Create the log file if it doesn't exist
if (-not (Test-Path $logFile)) {
    New-Item -Path $logFile -ItemType File -Force
}

# Function to log messages
function Log-Message {
    param (
        [string]$Message
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
}

# Check if winget is available
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Log-Message "winget is not installed on this system."
    exit
}

# Get list of upgradable packages
$upgradablePackages = winget upgrade --accept-source-agreements --accept-package-agreements --silent | 
    Where-Object { $_ -match "Upgradable" }

if ($upgradablePackages) {
    Log-Message "The following packages need updating:"
    $upgradablePackages | ForEach-Object {
        Log-Message $_
    }

    # Update each package with verbose logging
    foreach ($package in $upgradablePackages) {
        # Extract package ID from the output
        if ($package -match '^\s*(\S+)') {
            $packageId = $matches[1]
            Log-Message "Updating package: $packageId"
            
            # Execute the update command
            try {
                winget upgrade --id $packageId --accept-source-agreements --accept-package-agreements --verbose
                Log-Message "Successfully updated package: $packageId"
            } catch {
                Log-Message "Failed to update package: $packageId. Error: $_"
            }
        }
    }
} else {
    Log-Message "No packages need updating."
}