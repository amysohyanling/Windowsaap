...
# Import the SCCM module (set to correct path if necessary)
Import-Module "$($Env:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
 
# Connect to the SCCM site
cd "SCCM:"
 
# Trigger the deployment
Invoke-CMDeploymentSummarization -DeploymentID $UpdateDeploymentID
...

# Import the SCCM module (adjust the path as needed)
$modulePath = "$($Env:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1"
if (Test-Path $modulePath) {
    Import-Module $modulePath
    Write-Host "SCCM module imported successfully."
} else {
    Write-Host "Error: SCCM module path is invalid. Check the SMS_ADMIN_UI_PATH environment variable."
    return
}

# Connect to the SCCM site
try {
    cd "SCCM:"
    Write-Host "Connected to the SCCM site."
} catch {
    Write-Host "Error: Unable to connect to the SCCM site. Ensure SCCM is configured correctly."
    return
}

# 1. Get Inventory Data (for a specific machine or all machines)
# Example: Get the hardware inventory for a specific machine
$deviceName = "ClientPCName"  # Replace with the actual device name or use a loop to gather all machines' inventory
$inventoryData = Get-CMDevice -Name $deviceName
if ($inventoryData) {
    Write-Host "Inventory data for $deviceName:"
    $inventoryData | Format-List
} else {
    Write-Host "No inventory data found for $deviceName."
}

# 2. Get Packages in SCCM
# Fetching all packages in SCCM
$packages = Get-CMPackage
if ($packages) {
    Write-Host "Available packages in SCCM:"
    $packages | Format-Table Name, PackageID, Version
} else {
    Write-Host "No packages found in SCCM."
}

# 3. Update the Packages
# Loop through each package and trigger an update (this could be deploying or updating the package metadata)
foreach ($package in $packages) {
    try {
        # Assuming this is for redeploying or triggering a summarization
        Write-Host "Updating package: $($package.Name) - ID: $($package.PackageID)"
        Invoke-CMDeploymentSummarization -DeploymentID $package.PackageID
    } catch {
        Write-Host "Error updating package $($package.Name): $_"
    }
}


