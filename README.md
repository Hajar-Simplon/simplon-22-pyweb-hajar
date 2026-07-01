# PyWeb - Azure Container Apps Deployment

## Overview

This project demonstrates the deployment of a simple Python Flask application to **Azure Container Apps (ACA)** using **GitLab CI/CD**.

The application is containerized with Docker, stored in **Azure Container Registry (ACR)** and deployed automatically through a GitLab pipeline authenticated with **OpenID Connect (OIDC)**. No passwords, client secrets or certificates are stored in the CI/CD pipeline.

---

# Architecture

```
                 GitLab CI/CD
                       │
                 OIDC Authentication
                       │
                       ▼
             Azure Managed Identity
                       │
                       ▼
        Azure Container Registry (ACR)
                       │
                 Docker Image
                       │
                       ▼
        Azure Container Apps (ACA)
                       │
                       ▼
              Python Flask Application
```

---

# Technologies

- Python 3.14
- Flask
- Docker
- GitLab CI/CD
- GitLab SAST
- Azure CLI
- Azure Container Registry (ACR)
- Azure Container Apps (ACA)
- Azure Managed Identity
- OpenID Connect (OIDC)
- PowerShell
- GNU Make

---

# Project Structure

```
.
├── app.py
├── Dockerfile
├── Makefile
├── requirements.txt
├── .gitlab-ci.yml
│
├── toolbox/
│   └── Dockerfile
│
├── infra/
│   ├── config.ps1
│   ├── create.ps1
│   ├── destroy.ps1
│   ├── identity.ps1
│   ├── federation.ps1
│   └── quickstart.ps1
│
└── README.md
```

---

# Infrastructure

Infrastructure automation is located inside the `infra` folder.

| Script | Description |
|---------|-------------|
| create.ps1 | Creates Azure infrastructure (Resource Group, ACR, ACA Environment and Container App) |
| destroy.ps1 | Deletes Azure resources created by the project (without deleting the Resource Group) |
| identity.ps1 | Creates the Managed Identity and assigns Azure roles |
| federation.ps1 | Configures GitLab OpenID Connect federation |
| config.ps1 | Centralized configuration |
| quickstart.ps1 | Optional helper script |

The infrastructure scripts are idempotent and can be executed multiple times safely.

---

# GitLab Pipeline

The GitLab pipeline contains four stages.

## Test

- Flake8
- GitLab SAST

---

## Build

The build stage:

- authenticates to Azure using OIDC
- builds the Docker image
- tags the image with the Git commit SHA
- pushes the image to Azure Container Registry

Docker image example:

```
pyweb-app:8a42f1d
```

---

## Deploy

The deploy stage:

- authenticates with Azure using OIDC
- deploys the latest image to Azure Container Apps
- updates the staging environment

---

## Infrastructure (Bonus)

Two manual jobs are available:

- infra:setup
- infra:teardown

These jobs execute the PowerShell infrastructure scripts.

---

# Authentication

Authentication between GitLab and Azure uses **OpenID Connect (OIDC)**.

No Azure secrets are stored inside GitLab.

Authentication flow:

```
GitLab Pipeline
        │
Issues OIDC Token
        │
        ▼
Managed Identity
        │
        ▼
Azure validates the Federated Credential
        │
        ▼
Authorized deployment
```

---

# Image Versioning

Docker images are versioned using the Git commit SHA.

Example:

```
pyweb-app:3f82ab9
```

This guarantees traceability between a deployment and the corresponding Git commit.

---

# Toolbox Image

A dedicated Docker image is used by the GitLab pipeline.

It contains:

- Azure CLI
- Docker CLI
- GNU Make

Using a toolbox image avoids reinstalling these tools during every pipeline execution, making the pipeline faster and more reproducible.

---

# Running the Project Locally

## Build the application

```bash
docker build -t pyweb-app .
```

## Run the application

```bash
docker run -p 8080:8080 pyweb-app
```

Application:

```
http://localhost:8080
```

Logs:

```
http://localhost:8080/logs
```

---

# Infrastructure Commands

Create infrastructure:

```powershell
pwsh ./infra/create.ps1
```

Create Managed Identity:

```powershell
pwsh ./infra/identity.ps1
```

Configure GitLab OIDC:

```powershell
pwsh ./infra/federation.ps1
```

Delete infrastructure:

```powershell
pwsh ./infra/destroy.ps1
```

---

# Design Choices

The following design decisions were made during this project:

- Authentication uses OpenID Connect instead of client secrets.
- Azure Managed Identity is used to authenticate GitLab.
- Infrastructure automation is implemented using PowerShell.
- Infrastructure scripts are idempotent.
- Docker images are versioned using the Git commit SHA.
- A reusable toolbox image is used for GitLab CI jobs.
- Azure Container Registry stores application images.
- Azure Container Apps hosts the deployed application.

---

# References

- GitLab CI/CD Documentation
- GitLab OpenID Connect Documentation
- Azure Container Registry Documentation
- Azure Container Apps Documentation
- Azure Managed Identity Documentation