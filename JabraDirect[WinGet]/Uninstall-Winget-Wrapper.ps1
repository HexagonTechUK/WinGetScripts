<#
.SYNOPSIS
    Uninstalls Jabra Direct

.DESCRIPTION
   Winget PowerShell script to uninstall Jabra Direct via the Company Portal

.EXAMPLE
    .\Uninstall-Winget-Wrapper.ps1

.NOTES
    Author: Paul Gosling, Persimmon Homes
    Last Edit: 2024-07-22
    Version: 1.0
#>

# Variables (complete these):
$deployType     		= "Uninstall"   #------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$productName    		= "JabraDirect"   #----------------------------------------------------# Application name for logfile
$ProgramName 			= "Jabra.Direct"   #---------------------------------------------------# Deployment type: Install, Upgrade, Removal
$transcriptFileName		= Join-Path $env:ProgramData "PH\$deployType-$productName.log"   #-----#

# Start logging
Start-Transcript -Path $transcriptFileName

# resolve winget_exe
$winget_exe = Resolve-Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller_*_*__8wekyb3d8bbwe\winget.exe"
if ($winget_exe.count -gt 1){
        $winget_exe = $winget_exe[-1].Path
}

if (!$winget_exe){Write-Error "Winget not installed"}

& $winget_exe uninstall --exact --id $ProgramName --silent --accept-source-agreements

# Conclude logging
Stop-Transcript
