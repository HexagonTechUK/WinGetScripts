<#
.SYNOPSIS
    Installs Microsoft PowerBI

.DESCRIPTION
   Winget PowerShell script to install Microsoft PowerBI via the Company Portal

.EXAMPLE
    .\Install-Winget-Wrapper.ps1

.NOTES
    Author: Paul Gosling, Persimmon Homes
    Last Edit: 2024-08-21
    Version: Latest
#>

# Variables (complete these):
$deployType     		= "Install"   #--------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$productName    		= "PowerBI"   #--------------------------------------------------------# Application name for logfile
$ProgramName 			= "Microsoft.PowerBI"   #--------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$transcriptFileName		= Join-Path $env:ProgramData "PH\$deployType-$productName.log"   #-----#

# Start logging
Start-Transcript -Path $transcriptFileName

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope=machine $param

Stop-Transcript