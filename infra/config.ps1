# Azure

$ResourceGroup = "hmezouarRG"
$Location = "francecentral"

# Azure Container Registry

$AcrName = "acrhajar2026"

# Azure Container Apps

$EnvironmentName = "env-hajar-aca"
$ContainerAppName = "aca-pyweb-hajar"

# Temporary image

$Image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"

# Application

$TargetPort = 8080

# ==========================================
# Managed Identity
# ==========================================

$ManagedIdentityName = "mi-gitlab-aca"

# ==========================================
# Azure Roles
# ==========================================

$AcrPushRole = "AcrPush"
$ContainerRegistryRole = "Container Registry Contributor"
$ContainerAppsRole = "Azure Container Apps Contributor"

# ==========================================
# GitLab OIDC
# ==========================================

$GitLabIssuer = "https://gitlab.com"
$GitLabProjectPath = "hajarmezouar/simplon-22-pyweb-hajar"
$GitLabBranch = "feature/azure-container-apps"
$FederatedCredentialName = "gitlab-feature"
$Audience = "api://AzureADTokenExchange"