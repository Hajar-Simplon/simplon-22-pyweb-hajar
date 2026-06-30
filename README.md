# Python Web Application - Azure Container Apps Deployment

## Project Overview

This project demonstrates the deployment of a Python web application to **Azure Container Apps** using a complete CI/CD pipeline on **GitLab CI**.

The infrastructure is automated with **Azure CLI** and **PowerShell** scripts, while authentication between GitLab and Azure is secured using **OpenID Connect (OIDC)** and a **User Assigned Managed Identity**, without storing any secrets in the pipeline.

---

## Architecture

```
GitLab
    │
    │ Commit
    ▼
GitLab CI
    │
    ├── Test
    ├── Build
    ├── Push image to Azure Container Registry
    └── Deploy to Azure Container Apps
            │
            ▼
Azure Container Registry
            │
            ▼
Azure Container Apps
```

---

## Technologies

- Python 3.14
- Docker
- GitLab CI/CD
- Azure CLI
- Azure Container Registry (ACR)
- Azure Container Apps (ACA)
- Azure Managed Identity
- OpenID Connect (OIDC)
- PowerShell

---

## Project Structure

```
.
├── infra/
│   ├── config.ps1
│   ├── create.ps1
│   ├── destroy.ps1
│   ├── identity.ps1
│   └── federation.ps1
│
├── app.py
├── Dockerfile
├── Makefile
├── requirements.txt
└── .gitlab-ci.yml
```

---

## Infrastructure Automation

Infrastructure provisioning is automated with PowerShell scripts.

### Create Azure infrastructure

```powershell
.\infra\create.ps1
```

Creates:

- Resource Group
- Azure Container Registry
- Azure Container Apps Environment
- Azure Container App

---

### Configure Managed Identity

```powershell
.\infra\identity.ps1
```

Creates:

- User Assigned Managed Identity
- Contributor role
- AcrPush role

---

### Configure OIDC Federation

```powershell
.\infra\federation.ps1
```

Creates the Federated Credential allowing GitLab CI to authenticate to Azure using OIDC.

---

### Destroy infrastructure

```powershell
.\infra\destroy.ps1
```

Deletes all Azure resources created for the project.

---

## Local Development

Build the Docker image:

```bash
make build
```

Run the application:

```bash
make run
```

Restart the container:

```bash
make restart
```

Remove the container:

```bash
make kill
```

---

## CI/CD Pipeline

The GitLab pipeline contains the following stages:

### Test

- Flake8
- Pytest
- GitLab SAST

### Build

- Authenticate to Azure using OIDC
- Build the Docker image
- Push the image to Azure Container Registry

Images are versioned using the Git commit short SHA:

```
pyweb-app:$CI_COMMIT_SHORT_SHA
```

### Deploy

- Authenticate to Azure using OIDC
- Deploy the new image to Azure Container Apps

---

## Authentication

The project does not use passwords, certificates or client secrets.

Authentication is performed using:

- GitLab Identity Token (OIDC)
- Azure Managed Identity
- Federated Credential

This allows GitLab CI to authenticate securely to Azure.

---

## Azure Resources

- Resource Group: `rg-hajar-aca-prf2026`
- Azure Container Registry: `acrhajar2026`
- Container Apps Environment: `env-hajar-aca`
- Container App: `aca-pyweb-hajar`

---

## Author

Hajar Mezouar