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
Write-Host "Save this value in GitLab as:"
Write-Host "AZURE_CLIENT_ID = $ClientId"

Write-Host ""
Write-Host "Principal ID:"
Write-Host $PrincipalId

# ------------------------------------------
# Get Azure Resource IDs
# ------------------------------------------

$AcrId = az acr show `
    --resource-group $ResourceGroup `
    --name $AcrName `
    --query id `
    -o tsv

Write-Host ""
Write-Host "Checking Container App..."

$appExists = az containerapp list `
    --resource-group $ResourceGroup `
    --query "[?name=='$ContainerAppName'].name" `
    -o tsv

if (-not $appExists) {

    throw "Container App '$ContainerAppName' does not exist. Run create.ps1 first."

}

$ContainerAppId = az containerapp show `
    --name $ContainerAppName `
    --resource-group $ResourceGroup `
    --query id `
    -o tsv

# ------------------------------------------
# AcrPush Role
# ------------------------------------------

Write-Host ""
Write-Host "Checking AcrPush role..."

$acrRoleExists = az role assignment list `
    --assignee-object-id $PrincipalId `
    --scope $AcrId `
    --query "[?roleDefinitionName=='$AcrRole'].id" `
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

# ------------------------------------------
# Container Registry Contributor Role
# ------------------------------------------

Write-Host ""
Write-Host "Checking Container Registry Contributor role..."

$containerRegistryRoleExists = az role assignment list `
    --assignee-object-id $PrincipalId `
    --scope $AcrId `
    --query "[?roleDefinitionName=='$ContainerRegistryRole'].id" `
    -o tsv

if ($containerRegistryRoleExists) {

    Write-Host "Container Registry Contributor role already assigned."

}
else {

    Write-Host "Assigning Container Registry Contributor..."

    az role assignment create `
        --assignee-object-id $PrincipalId `
        --assignee-principal-type ServicePrincipal `
        --role $ContainerRegistryRole `
        --scope $AcrId

}

# ------------------------------------------
# Azure Container Apps Contributor Role
# ------------------------------------------

Write-Host ""
Write-Host "Checking Azure Container Apps Contributor role..."

$containerAppsRoleExists = az role assignment list `
    --assignee-object-id $PrincipalId `
    --scope $ContainerAppId `
    --query "[?roleDefinitionName=='$ContainerAppsRole'].id" `
    -o tsv

if ($containerAppsRoleExists) {

    Write-Host "Azure Container Apps Contributor role already assigned."

}
else {

    Write-Host "Assigning Azure Container Apps Contributor..."

    az role assignment create `
        --assignee-object-id $PrincipalId `
        --assignee-principal-type ServicePrincipal `
        --role $ContainerAppsRole `
        --scope $ContainerAppId

}

Write-Host ""
Write-Host "Managed Identity successfully configured."