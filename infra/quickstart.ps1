# ==========================================
# Azure Managed Identity Configuration
# ==========================================

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/config.ps1"

Write-Host ""
Write-Host "===================================="
Write-Host " Azure Managed Identity Setup"
Write-Host "===================================="
Write-Host ""

# --------------------------------------------------
# Managed Identity
# --------------------------------------------------

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

# --------------------------------------------------
# IDs
# --------------------------------------------------

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

# --------------------------------------------------
# Resource IDs
# --------------------------------------------------

$AcrId = az acr show `
    --resource-group $ResourceGroup `
    --name $AcrName `
    --query id `
    -o tsv

$RgId = az group show `
    --name $ResourceGroup `
    --query id `
    -o tsv

# --------------------------------------------------
# AcrPush Role
# --------------------------------------------------

Write-Host ""
Write-Host "Checking AcrPush role..."

$acrRoleExists = az role assignment list `
    --assignee-object-id $PrincipalId `
    --scope $AcrId `
    --query "[?roleDefinitionName=='$AcrRole'].roleDefinitionName" `
    -o tsv

if ($acrRoleExists) {

    Write-Host "AcrPush role already assigned."

}
else {

    Write-Host "Assigning AcrPush..."

    az role assignment create `
        --assignee-object-id $PrincipalId `
        --assignee-principal-type ServicePrincipal `
        --role $AcrRole `
        --scope $AcrId

}

# --------------------------------------------------
# Container Apps Contributor Role
# --------------------------------------------------

Write-Host ""
Write-Host "Checking Container Apps Contributor role..."

$containerRoleExists = az role assignment list `
    --assignee-object-id $PrincipalId `
    --scope $RgId `
    --query "[?roleDefinitionName=='$ContainerAppsRole'].roleDefinitionName" `
    -o tsv

if ($containerRoleExists) {

    Write-Host "Container Apps Contributor role already assigned."

}
else {

    Write-Host "Assigning Container Apps Contributor..."

    az role assignment create `
        --assignee-object-id $PrincipalId `
        --assignee-principal-type ServicePrincipal `
        --role "$ContainerAppsRole" `
        --scope $RgId

}

# --------------------------------------------------
# Summary
# --------------------------------------------------

Write-Host ""
Write-Host "===================================="
Write-Host " Managed Identity Ready"
Write-Host "===================================="

Write-Host ""
Write-Host "Client ID:"
Write-Host $ClientId

Write-Host ""
Write-Host "Principal ID:"
Write-Host $PrincipalId