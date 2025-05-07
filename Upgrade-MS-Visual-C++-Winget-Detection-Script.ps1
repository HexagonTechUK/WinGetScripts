<#
.SYNOPSIS
    Intune Detection Script to check if Visual C++ Redistributables are installed.

.DESCRIPTION
    This script checks if at least one version of Microsoft Visual C++ Redistributable is installed. It always returns an exit code of 1 to trigger remediation regardless of the detection result.

.EXAMPLE
    .\Detect-VCRedist.ps1

.NOTES
    Author: Mohammed Kahar, Persimmon Homes
    Last Edit: 18/10/2024
#>

# List of Visual C++ Redistributable packages to check
$requiredPackages = @(
    'Microsoft.VCRedist.2008.x64',
    'Microsoft.VCRedist.2008.x86',
    'Microsoft.VCRedist.2010.x64',
    'Microsoft.VCRedist.2010.x86',
    'Microsoft.VCRedist.2012.x64',
    'Microsoft.VCRedist.2012.x86',
    'Microsoft.VCRedist.2013.x64',
    'Microsoft.VCRedist.2013.x86',
    'Microsoft.VCRedist.2015+.x64'
)

# Function to check if a package is installed
function Is-PackageInstalled {
    param (
        [string]$packageId
    )

    # Use winget to check if the package is installed
    $installedPackage = winget list --id $packageId --accept-source-agreements --accept-package-agreements | Where-Object { $_ -match $packageId }

    if ($installedPackage) {
        return $true
    } else {
        return $false
    }
}

# Flag to track if at least one package is installed
$atLeastOnePackageInstalled = $false

# Check if any of the required packages are installed
foreach ($packageId in $requiredPackages) {
    if (Is-PackageInstalled -packageId $packageId) {
        $atLeastOnePackageInstalled = $true
        break  # Exit the loop since we only need one package to be installed
    }
}

# Log the result for information
if ($atLeastOnePackageInstalled) {
    Write-Output "At least one required package is installed."
} else {
    Write-Output "No required packages are installed."
}

# Force the script to always return exit 1 to trigger remediation
exit 1  # Ensure remediation is always triggered
