<#
.SYNOPSIS
    Uninstalls Adobe.Acrobat.Pro

.DESCRIPTION
   Winget PowerShell script to install Adobe.Acrobat.Pro via the Company Portal

.EXAMPLE
    .\Uninstall-Winget-Wrapper.ps1

.NOTES
    Author: Jack Harris, Persimmon Homes
    Last Edit: 2024-07-10
    Version: 1.0
#>

# Variables (complete these):
$deployType     	= "Uninstall"   #------------------------------------------------------# Deployment type: Install, Upgrade, Removal
$productName    	= "Adobe.Acrobat.Pro"   #----------------------------------------------# Application name for logfile
$ProgramName 		= "Adobe.Acrobat.Pro"   #----------------------------------------------# Deployment type: Install, Upgrade, Removal
$transcriptFileName	= Join-Path $env:ProgramData "PH\$deployType-$productName.log"   #-----#

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
