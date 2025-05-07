<#
.SYNOPSIS
    Updates Google Chrome

.DESCRIPTION
   Winget PowerShell script to install Google.Chrome via the Company Portal

.EXAMPLE
    .\Winget-Update.ps1

.NOTES
    Author: Paul Gosling, Persimmon Homes
    Last Edit: 2024-08/05
    Version: 1.0
#>

# Variables (complete these):
$deployType     		= "Update"    #--------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$productName    		= "GoogleChrome"   #--------------------------------------------------------# Application name for logfile
$ProgramName 			= "Google.Chrome"   #--------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$transcriptFileName		= Join-Path $env:ProgramData "PH\$deployType-$productName.log"   #-----#

# Start logging
Start-Transcript -Path $transcriptFileName

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe update --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements --scope=machine $param

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){
    Write-Error "Winget not installed"
}else{
    $wingetPrg_Existing = & $winget_exe list --id $ProgramName --exact --accept-source-agreements
        if ($wingetPrg_Existing -like "*$ProgramName*"){
        Write-Host "Found it!"
    }
}

Stop-Transcript