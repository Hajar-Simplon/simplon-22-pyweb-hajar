# ==========================================
# Managed Identity Configuration
# ==========================================

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/config.ps1"

Write-Host ""
Write-Host "===================================="
Write-Host " Azure Managed Identity Setup"
Write-Host "===================================="
Write-Host ""

# ------------------------------------------
# Create Managed Identity
# ------------------------------------------

Write-Host "Checking Managed Identity..."

$identity = az identity list `
    --resource-group $ResourceGroup `
    --query "[?name=='$ManagedIdentityName'].name" `
    -o tsv

if ($identity) {

    Write-Host "Managed Identity already exists."

}
else {

    Write-Host "Creating Managed Identity..."

    az identity create `
        --resource-group $ResourceGroup `
        --name $ManagedIdentityName `
        --location $Location

}

# ------------------------------------------
# Get IDs
# ------------------------------------------

$PrincipalId = az identity show `
    --resource-group $ResourceGroup `
    --name $ManagedIdentityName `
    --query principalId `
    -o tsv

$ClientId = az identity show `
    --resource-group $ResourceGroup `
    --name $ManagedIdentityName `
    --query clientId `
    -o tsv

Write-Host ""
Write-Host "Client ID:"
Write-Host $ClientId

Write-Host ""
Write-Host "Principal ID:"
Write-Host $PrincipalId

# ------------------------------------------
# ACR Role
# ------------------------------------------

Write-Host ""
Write-Host "Assigning AcrPush..."

$AcrId = az acr show `
    --resource-group $ResourceGroup `
    --name $AcrName `
    --query id `
    -o tsv

az role assignment create `
    --assignee-object-id $PrincipalId `
    --assignee-principal-type ServicePrincipal `
    --role $AcrRole `
    --scope $AcrId

# ------------------------------------------
# Container Apps Role
# ------------------------------------------

Write-Host ""
Write-Host "Assigning Container Apps Contributor..."

$RgId = az group show `
    --name $ResourceGroup `
    --query id `
    -o tsv

az role assignment create `
    --assignee-object-id $PrincipalId `
    --assignee-principal-type ServicePrincipal `
    --role "$ContainerAppsRole" `
    --scope $RgId

Write-Host ""
Write-Host "Managed Identity successfully configured."