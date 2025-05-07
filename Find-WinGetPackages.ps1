# Find WinGet packages
$packages = Find-WinGetPackage ""

# Convert the output to HTML
$html = $packages | ConvertTo-Html -Property Id, Name, Version, Source

# Add a title to the HTML
$html = $html | Out-String
$html = "<html><head><title>WinGet Packages</title></head><body>$html</body></html>"

# Save the HTML to a file
$html | Set-Content -Path "C:\Admins\InTuneDeployments\01-Repos\winget-packages.html"

# Optionally, open the HTML file in the default browser
Start-Process "C:\Admins\InTuneDeployments\01-Repos\winget-packages.html"
