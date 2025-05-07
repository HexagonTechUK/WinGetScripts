<#
.SYNOPSIS
    Google Chrome Beta install check

.DESCRIPTION
   Winget PowerShell script to check that Google Chrome Beta has installed successfully.

.EXAMPLE
    .\Winget-Check.ps1

.NOTES
    Author: Paul Gosling, Persimmon Homes
    Last Edit: 2024-07-05
    Version: 1.0
#>

$ProgramName = "Google.Chrome.Beta"

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
