# ==========================
# Azure Infrastructure Setup
# ==========================

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/config.ps1"

Write-Host ""
Write-Host "===================================="
Write-Host " Azure Infrastructure Provisioning"
Write-Host "===================================="
Write-Host ""

# -----------------------------------
# Resource Group
# -----------------------------------

Write-Host ""
Write-Host "Checking Resource Group..."

$rgExists = az group exists --name $ResourceGroup

if ($rgExists -eq "true") {

    Write-Host "Resource Group already exists."

}
else {

    Write-Host "Creating Resource Group..."

    az group create `
        --name $ResourceGroup `
        --location $Location

}

# -----------------------------------
# Azure Container Registry
# -----------------------------------

Write-Host ""
Write-Host "Checking Azure Container Registry..."

$acrExists = az acr list `
    --resource-group $ResourceGroup `
    --query "[?name=='$AcrName'].name" `
    -o tsv

if ($acrExists) {

    Write-Host "Azure Container Registry already exists."

}
else {

    Write-Host "Creating Azure Container Registry..."

    az acr create `
        --resource-group $ResourceGroup `
        --name $AcrName `
        --sku Basic

}

# -----------------------------------
# Container Apps Environment
# -----------------------------------

Write-Host ""
Write-Host "Checking Container Apps Environment..."

$envExists = az containerapp env list `
    --resource-group $ResourceGroup `
    --query "[?name=='$EnvironmentName'].name" `
    -o tsv

if ($envExists) {

    Write-Host "Container Apps Environment already exists."

}
else {

    Write-Host "Creating Container Apps Environment..."

    az containerapp env create `
        --name $EnvironmentName `
        --resource-group $ResourceGroup `
        --location $Location

}

# -----------------------------------
# Container App
# -----------------------------------

Write-Host ""
Write-Host "Checking Container App..."

$appExists = az containerapp list `
    --resource-group $ResourceGroup `
    --query "[?name=='$ContainerAppName'].name" `
    -o tsv

if ($appExists) {

    Write-Host "Container App already exists."

}
else {

    Write-Host "Creating Container App..."

    az containerapp create `
        --name $ContainerAppName `
        --resource-group $ResourceGroup `
        --environment $EnvironmentName `
        --image $Image `
        --target-port $TargetPort `
        --ingress external `
        --system-assigned

}

# -----------------------------------
# Container App Managed Identity
# -----------------------------------

Write-Host ""
Write-Host "Checking Container App Managed Identity..."

$IdentityType = az containerapp show `
    --name $ContainerAppName `
    --resource-group $ResourceGroup `
    --query identity.type `
    -o tsv

if ($IdentityType -eq "SystemAssigned") {

    Write-Host "Managed Identity already assigned."

}
else {

    Write-Host "Assigning Managed Identity..."

    az containerapp identity assign `
        --name $ContainerAppName `
        --resource-group $ResourceGroup `
        --system-assigned

    Write-Host "Waiting for Managed Identity propagation..."
    Start-Sleep -Seconds 15

}

# -----------------------------------
# AcrPull Role
# -----------------------------------

Write-Host ""
Write-Host "Checking AcrPull role assignment..."

$ContainerPrincipalId = az containerapp show `
    --name $ContainerAppName `
    --resource-group $ResourceGroup `
    --query identity.principalId `
    -o tsv

$AcrId = az acr show `
    --resource-group $ResourceGroup `
    --name $AcrName `
    --query id `
    -o tsv

$AcrPullExists = az role assignment list `
    --assignee-object-id $ContainerPrincipalId `
    --scope $AcrId `
    --query "[?roleDefinitionName=='$AcrPullRole'].id" `
    -o tsv

if ($AcrPullExists) {

    Write-Host "AcrPull role already assigned."

}
else {

    Write-Host "Assigning AcrPull role..."

    az role assignment create `
        --assignee-object-id $ContainerPrincipalId `
        --assignee-principal-type ServicePrincipal `
        --role $AcrPullRole `
        --scope $AcrId

}

# -----------------------------------
# Configure Azure Container Registry
# -----------------------------------

Write-Host ""
Write-Host "Checking Container App registry..."

$registryConfigured = az containerapp registry list `
    --name $ContainerAppName `
    --resource-group $ResourceGroup `
    --query "[?server=='$AcrName.azurecr.io'].server" `
    -o tsv

if ($registryConfigured) {

    Write-Host "Container Registry already configured."

}
else {

    Write-Host "Configuring Container App registry..."

    az containerapp registry set `
        --name $ContainerAppName `
        --resource-group $ResourceGroup `
        --server "$AcrName.azurecr.io" `
        --identity system

}

# -----------------------------------
# Configure GitLab Managed Identity
# -----------------------------------

Write-Host ""
Write-Host "Configuring GitLab Managed Identity..."

pwsh "$PSScriptRoot/identity.ps1"

# -----------------------------------
# Configure GitLab OIDC Federation
# -----------------------------------

Write-Host ""
Write-Host "Configuring GitLab OIDC Federation..."

pwsh "$PSScriptRoot/federation.ps1"

Write-Host ""
Write-Host "===================================="
Write-Host "Infrastructure is up to date."
Write-Host "===================================="