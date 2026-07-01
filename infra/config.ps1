# ==========================================
# Azure
# ==========================================

$ResourceGroup = "hmezouarRG"
$Location = "francecentral"

# ==========================================
# Azure Container Registry
# ==========================================

$AcrName = "acrhajar2026"

# ==========================================
# Azure Container Apps
# ==========================================

$EnvironmentName = "env-hajar-aca"
$ContainerAppName = "aca-pyweb-hajar"

# ==========================================
# Temporary Image
# ==========================================

$Image = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"

# ==========================================
# Application
# ==========================================

$TargetPort = 8080

# ==========================================
# Managed Identity
# ==========================================

$ManagedIdentityName = "mi-gitlab-aca"

# ==========================================
# Azure Roles
# ==========================================

# GitLab Managed Identity → Push Docker images
$AcrRole = "AcrPush"

# GitLab Managed Identity → Read the Resource Group
$ResourceGroupReaderRole = "Reader"

# GitLab Managed Identity → Manage the Container App
$ContainerAppsRole = "Container Apps Contributor"

# Container App System Managed Identity → Pull images from ACR
$AcrPullRole = "AcrPull"

# ==========================================
# GitLab OIDC
# ==========================================

$GitLabIssuer = "https://gitlab.com"
$GitLabProjectPath = "hajarmezouar/simplon-22-pyweb-hajar"
$GitLabBranch = "feature/azure-container-apps"
$FederatedCredentialName = "gitlab-feature"
$Audience = "api://AzureADTokenExchange"