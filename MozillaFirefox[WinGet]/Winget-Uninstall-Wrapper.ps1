<#
.SYNOPSIS
    This script will uninstall Mozilla Firefox.

.DESCRIPTION
   This script will uninstall Mozilla Firefox via WinGet.

.EXAMPLE
    .\ScriptName.ps1

.NOTES
    Author: Jack Harris, Persimmon Homes
    Last Edit: 2024-07-03
    Version: 1.0
#>

# Variables (complete these):
$deployType     = "Removal"    #-----------------------------------------------------# Deployment type: Install, Upgrade, Removal
$productName    = "Mozilla Firefox"   #-----------------------------------------------------# Application name for logfile
$ProgramName    = "Mozilla.Firefox"      #-----------------------------------------------------# Winget Program ID
$logFileName    = Join-Path $env:ProgramData "PH\$deployType-$productName.log"  #---------# Path to app logfile

# Start logging
Start-Transcript -Path $logFileName

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe uninstall --exact --id $ProgramName --silent --accept-source-agreements

# Conclude logging
Stop-Transcript