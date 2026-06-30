# Azure Container Apps Deployment

## Azure Resources

| Resource | Name |
|----------|------|
| Resource Group | rg-hajar-aca-prf2026 |
| Azure Container Registry | acrhajar2026 |
| Container Apps Environment | env-hajar-aca |
| Container App | aca-pyweb-hajar |
| Region | francecentral |

## Infrastructure

The infrastructure is managed through PowerShell scripts located in the `infra/` directory.

### Create infrastructure

```powershell
.\infra\create.ps1
```

### Destroy infrastructure

```powershell
.\infra\destroy.ps1
```

or

```bash
make infra-create
make infra-destroy
```

## Current CI/CD

- Test stage
- Lint
- SAST
- Docker image build

> The deployment to Azure Container Apps using OIDC will be implemented in the next step.