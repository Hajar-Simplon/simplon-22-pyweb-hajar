# ==========================
# Azure Infrastructure Cleanup
# ==========================

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/config.ps1"

Write-Host ""
Write-Host "===================================="
Write-Host " Azure Infrastructure Cleanup"
Write-Host "===================================="
Write-Host ""

# -----------------------------------
# Container App
# -----------------------------------

Write-Host ""
Write-Host "Deleting Container App..."

az containerapp delete `
    --name $ContainerAppName `
    --resource-group $ResourceGroup `
    --yes 2>$null

# -----------------------------------
# Container Apps Environment
# -----------------------------------

Write-Host ""
Write-Host "Deleting Container Apps Environment..."

az containerapp env delete `
    --name $EnvironmentName `
    --resource-group $ResourceGroup `
    --yes 2>$null

# -----------------------------------
# Azure Container Registry
# -----------------------------------

Write-Host ""
Write-Host "Deleting Azure Container Registry..."

az acr delete `
    --name $AcrName `
    --resource-group $ResourceGroup `
    --yes 2>$null

Write-Host ""
Write-Host "Infrastructure successfully deleted."