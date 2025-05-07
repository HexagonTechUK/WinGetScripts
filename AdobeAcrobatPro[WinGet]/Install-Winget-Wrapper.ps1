<#
.SYNOPSIS
    Installs Adobe.Acrobat.Pro

.DESCRIPTION
   Winget PowerShell script to install Adobe Acrobat Pro via the Company Portal

.EXAMPLE
    .\Install-Winget-Wrapper.ps1

.NOTES
    Author: Jack Harris, Persimmon Homes
    Last Edit: 2024-07-10
    Version: 1.0
#>

# Variables (complete these):
$deployType     	= "Install"   #--------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$productName    	= "AdobeAcrobatPro"   #--------------------------------------------------------# Application name for logfile
$ProgramName 		= "Adobe.Acrobat.Pro"   #--------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$transcriptFileName	= Join-Path $env:ProgramData "PH\$deployType-$productName.log"   #-----#

# Start logging
Start-Transcript -Path $transcriptFileName

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe install --exact --id $ProgramName --silent --accept-package-agreements --accept-source-agreements $param

Stop-Transcript