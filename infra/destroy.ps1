# =============================
# Azure Infrastructure Cleanup
# =============================

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/config.ps1"

Write-Host ""
Write-Host "===================================="
Write-Host " Azure Infrastructure Cleanup"
Write-Host "===================================="
Write-Host ""

$exists = az group exists --name $ResourceGroup

if ($exists -eq "true") {

    Write-Host "Deleting Resource Group..."

    az group delete `
        --name $ResourceGroup `
        --yes

    Write-Host ""
    Write-Host "Infrastructure successfully deleted."

}
else {

    Write-Host "Resource Group does not exist."

}