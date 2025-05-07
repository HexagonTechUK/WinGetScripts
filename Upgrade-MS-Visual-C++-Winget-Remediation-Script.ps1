<#
.SYNOPSIS
    Upgrades specific Winget packages (Microsoft Visual C++ Redistributables) in Intune remediation task, handling missing packages.

.DESCRIPTION
    PowerShell script to upgrade specific Winget packages for Microsoft Visual C++ Redistributables, designed for Intune remediation tasks, with checks for missing packages.

.EXAMPLE
    .\Upgrade-Winget.ps1

.NOTES
    Author: Mohammed Kahar, Persimmon Homes
    Last Edit: 18/10/2024
#>

# Define log file path
$logFile = Join-Path $env:ProgramData "PH\Upgrade-MS-Visual-C++-Winget.log"

# Create the log file if it doesn't exist
if (-not (Test-Path $logFile)) {
    New-Item -Path $logFile -ItemType File -Force
}

# Function to log messages (to both file and Intune output)
function Log-Message {
    param (
        [string]$Message
    )
    $timestamp = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    "$timestamp - $Message" | Out-File -FilePath $logFile -Append
    Write-Output "$timestamp - $Message"  # Also log to Intune output
}

#WebClient
$dc = New-Object net.webclient
$dc.UseDefaultCredentials = $true
$dc.Headers.Add("user-agent", "Internet Explorer")
$dc.Headers.Add("X-FORMS_BASED_AUTH_ACCEPTED", "f")

#temp folder
$InstallerFolder = $(Join-Path $env:ProgramData CustomScripts)
if (!(Test-Path $InstallerFolder)) {
    New-Item -Path $InstallerFolder -ItemType Directory -Force -Confirm:$false
}

# Check Winget Install
Log-Message "Checking if Winget is installed"
$TestWinget = Get-AppxProvisionedPackage -Online | Where-Object {$_.DisplayName -eq "Microsoft.DesktopAppInstaller"}
If ([Version]$TestWinGet.Version -gt "2022.506.16.0") {
    Log-Message "WinGet is Installed"
} else {
    # Download WinGet MSIXBundle
    Log-Message "Not installed. Downloading WinGet..."
    $WinGetURL = "https://aka.ms/getwinget"
    $dc.DownloadFile($WinGetURL, "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle")
    
    # Install WinGet MSIXBundle
    Try {
        Log-Message "Installing MSIXBundle for App Installer..."
        Add-AppxProvisionedPackage -Online -PackagePath "$InstallerFolder\Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" -SkipLicense
        Log-Message "Installed MSIXBundle for App Installer"
    } Catch {
        Log-Message "Failed to install MSIXBundle for App Installer. Error: $_"
    }
}

# List of package IDs to upgrade
$packages = @(
    "Microsoft.VCRedist.2008.x64",
    "Microsoft.VCRedist.2008.x86",
    "Microsoft.VCRedist.2010.x64",
    "Microsoft.VCRedist.2010.x86",
    "Microsoft.VCRedist.2012.x64",
    "Microsoft.VCRedist.2012.x86",
    "Microsoft.VCRedist.2013.x64",
    "Microsoft.VCRedist.2013.x86",
    "Microsoft.VCRedist.2015+.x64",
    "Microsoft.VCRedist.2015+.x86"
)

# Initialize tracking variables
$anyUpgraded = $false
$anyErrors = $false

# Function to clean Winget output (removing special characters)
function Clean-WingetOutput {
    param (
        [string]$output
    )
    # Remove non-printable characters (e.g., progress bars)
    return $output -replace '[^\x20-\x7E]', ''
}

# Loop through each package to upgrade
foreach ($packageId in $packages) {
    Log-Message "Attempting to upgrade package: $packageId"

    try {
        # Check for Winget path
        $ResolveWingetPath = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_x64__8wekyb3d8bbwe"
        if ($ResolveWingetPath) {
            $WingetPath = $ResolveWingetPath[-1].Path
        }
        Set-Location $WingetPath

        # Execute the winget upgrade command
        $upgradeOutput = .\winget.exe upgrade --id $packageId --silent --accept-package-agreements --accept-source-agreements --scope machine
        $cleanedOutput = Clean-WingetOutput $upgradeOutput
        
        if ($cleanedOutput -match "No applicable update found" -or $cleanedOutput -match "does not require an update") {
            Log-Message "Package already up to date: $packageId"
        } else {
            Log-Message "Upgrade output for package {$packageId}: $cleanedOutput"
            Log-Message "Successfully upgraded package: $packageId"
            $anyUpgraded = $true  # Track at least one upgrade
        }
    } catch {
        Log-Message "Failed to upgrade package: $packageId. Error: $_"
        $anyErrors = $true  # Track if any errors occur
    }
}

# Determine the result
if ($anyErrors) {
    Log-Message "One or more packages failed to upgrade. Remediation failed."
    exit 0  # Failure case
} elseif ($anyUpgraded) {
    Log-Message "At least one package was successfully upgraded."
    exit 1  # Success case (upgrades occurred)
} else {
    Log-Message "All packages are already up to date."
    exit 1  # Success case (no updates needed, but no errors)
}
