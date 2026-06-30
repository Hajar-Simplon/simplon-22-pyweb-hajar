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
# Register Azure Providers
# -----------------------------------

Write-Host "Registering Azure Resource Providers..."

az provider register --namespace Microsoft.App --wait
az provider register --namespace Microsoft.ContainerRegistry --wait
az provider register --namespace Microsoft.OperationalInsights --wait

# -----------------------------------
# Resource Group
# -----------------------------------

Write-Host ""
Write-Host "Creating Resource Group..."

az group create `
    --name $ResourceGroup `
    --location $Location

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
        --ingress external

}

Write-Host ""
Write-Host "Infrastructure is up to date."