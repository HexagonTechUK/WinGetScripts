<#
.SYNOPSIS
    Upgrades all versions of TeamViewer to latest version

.DESCRIPTION
   Uses Winget to download and install the latest version of TeamViewer Host.
   
.EXAMPLE
    .\Winget-Install-Wrapper-Host.ps1

.NOTES
    Author: Paul Gosling, Persimmon Homes
    Last Edit: 2024-07-04
    Version: LATEST
#>

# Variables (complete these):
$deployType     = "Update"   #--------------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$productName    = "TeamViewer"   #----------------------------------------------------------# Application name for logfile
$ProgramName    = "TeamViewer.TeamViewer"   #-----------------------------------------------# Winget Program ID
$logFileName    = Join-Path $env:ProgramData "PH\$deployType-$productName-Host.log"   #-----# Path to app logfile

# Start logging
Start-Transcript -Path $logFileName

# Terminate all running instances of TeamViewer
Get-Process -Name "$productName" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "Terminating $($_.ProcessName) process with ID $($_.Id)..."
    $_.Kill()
}

# Wait for a moment to ensure all processes are terminated
Start-Sleep -Seconds 5

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope=machine $param

# Conclude logging
Stop-Transcript