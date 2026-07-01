# ==========================================
# Azure Federated Credential Configuration
# ==========================================

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/config.ps1"

Write-Host ""
Write-Host "===================================="
Write-Host " GitLab OIDC Configuration"
Write-Host "===================================="
Write-Host ""

# ------------------------------------------
# Check Managed Identity
# ------------------------------------------

$identityExists = az identity list `
    --resource-group $ResourceGroup `
    --query "[?name=='$ManagedIdentityName'].name" `
    -o tsv

if (-not $identityExists) {

    throw "Managed Identity '$ManagedIdentityName' does not exist."

}

# ------------------------------------------
# Build Subject
# ------------------------------------------

$Subject = "project_path:${GitLabProjectPath}:ref_type:branch:ref:${GitLabBranch}"
Write-Host ""
Write-Host "OIDC Subject:"
Write-Host $Subject

# ------------------------------------------
# Check Existing Federated Credential
# ------------------------------------------

$federationExists = az identity federated-credential list `
    --identity-name $ManagedIdentityName `
    --resource-group $ResourceGroup `
    --query "[?name=='$FederatedCredentialName'].name" `
    -o tsv

if ($federationExists) {

    Write-Host ""
    Write-Host "Federated Credential already exists."

}
else {

    Write-Host ""
    Write-Host "Creating Federated Credential..."

    az identity federated-credential create `
        --name $FederatedCredentialName `
        --identity-name $ManagedIdentityName `
        --resource-group $ResourceGroup `
        --issuer $GitLabIssuer `
        --subject $Subject `
        --audience $Audience

}

Write-Host ""
Write-Host "GitLab OIDC configuration completed."